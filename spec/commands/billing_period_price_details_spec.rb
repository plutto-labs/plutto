require 'rails_helper'

describe BillingPeriodPriceDetails do
  before do
    Timecop.freeze
  end

  let(:customer) { create(:customer) }
  let(:billing_date) { Date.current + 30.days }
  let(:plan_subscription) { create(:plan_subscription, customer: customer) }
  let(:billing_period) do
    create(
      :billing_period,
      from: Date.current,
      to: Date.current + 30.days,
      plan_subscription: plan_subscription,
      billing_date: billing_date
    )
  end

  def mock_metered_price_logic
    meter = create(:meter)
    meter_count = create(:meter_count, meter: meter, count: 250, customer: customer)
    create(:billing_period_meter_data, initial_count: 10, final_count: 260,
           billing_period: billing_period, meter_count: meter_count)
    tiers_params = [{ price: usd(300), limit: 100 }, { price: usd(200), limit: 200 },
                    { price: usd(100), limit: 300 }]

    price_logic = create(:price_logic_volume, :with_tiers,
                         price: usd(100), tiers_params: tiers_params,
                         plan_version: plan_subscription.plan_version, meter: meter)

    allow(price_logic).to receive(:calculate_price).with(250).and_return(usd(100))
  end

  def mock_non_metered_price_logic
    price_logic = create(:price_logic_flat_fee, price: usd(100),
                                                plan_version: plan_subscription.plan_version)
    allow(price_logic).to receive(:calculate_price).with(250).and_return(usd(100))
  end

  def perform
    described_class.for(billing_period: billing_period)
  end

  describe '#perform' do
    before do
      mock_non_metered_price_logic
    end

    context 'when there is only one price logic' do
      it 'returns the correct price' do
        expect(perform[:price]).to eq(usd(100))
      end

      context 'with non-metered price_logic' do
        it 'saves the details for that price logic' do
          details = perform[:details]
          expect(details.size).to eq(1)
          expect(details[0][:total_price_cents]).to eq(usd(100).cents)
          expect(details[0][:type]).to eq('flat_fee')
        end
      end

      context 'with metered price_logic' do
        before do
          mock_metered_price_logic
        end

        it 'saves the details for that price logic' do
          details = perform[:details]
          expect(details.size).to eq(2)
          expect(details[0][:total_price_cents]).to eq(usd(100).cents)
          expect(details[0][:type]).to eq('flat_fee')
        end
      end
    end

    context 'when there are multiple price logic' do
      let(:price_logic_prices) { [usd(100), usd(100) * 250] }

      before do
        mock_metered_price_logic
      end

      it 'returns the correct price' do
        expect(perform[:price]).to eq(price_logic_prices[0] + price_logic_prices[1])
      end

      it 'saves the details for each price logic' do
        details = perform[:details]
        expect(details.size).to eq(2)
        expect(details[0][:total_price_cents]).to eq(price_logic_prices[0].cents)
        expect(details[0][:type]).to eq('flat_fee')
        expect(details[1][:total_price_cents]).to eq(price_logic_prices[1].cents)
        expect(details[1][:type]).to eq('volume')
      end

      context 'when billing period end before the end of period' do
        let(:billing_date) { Date.current + 14.days }

        it 'returns the correct price' do
          expected_price = price_logic_prices[0] * 0.5 + price_logic_prices[1]
          expect(perform[:price]).to eq(expected_price)
        end
      end

      context 'when billing period bills at start' do
        let(:billing_date) { nil }

        before do
          allow(plan_subscription).to receive(:bills_at_start?).and_return(true)
        end

        it 'returns the correct price' do
          expected_price = (usd(100) * 250 + usd(100)) * 1
          expect(perform[:price]).to eq(expected_price)
        end
      end
    end
  end
end
