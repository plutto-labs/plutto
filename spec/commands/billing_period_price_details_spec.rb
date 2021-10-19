require 'rails_helper'

describe BillingPeriodPriceDetails do
  before do
    Timecop.freeze
  end

  let(:customer) { create(:customer) }
  let(:subscription) { create(:subscription, customer: customer, permission_group: nil) }
  let!(:pricing_subscription) do
    create(:pricing_subscription, subscription: subscription)
  end
  let(:billing_period) do
    create(
      :billing_period,
      from: Date.current,
      to: Date.current + 30.days,
      subscription: subscription,
      billing_date: Date.current + 30.days
    )
  end

  def mock_metered_price_logic
    meter_count = create(:meter_count, meter: pricing_subscription.pricing.product.meter,
                                       count: 250, customer: customer)
    create(:billing_period_meter_data, initial_count: 10, final_count: 260,
           billing_period: billing_period, meter_count: meter_count)
    tiers_params = [{ price: usd(300), limit: 100 }, { price: usd(200), limit: 200 },
                    { price: usd(100), limit: 300 }]
    price_logic = create(:price_logic_volume, :with_tiers,
                         price: usd(100), tiers_params: tiers_params,
                         pricing: pricing_subscription.pricing)
    allow(price_logic).to receive(:calculate_price).with(250).and_return(usd(100))
  end

  def mock_non_metered_price_logic
    price_logic = create(:price_logic_flat_fee,
                         price: usd(100),
                         pricing: pricing_subscription.pricing)
    allow(price_logic).to receive(:calculate_price).with(250).and_return(usd(100))
  end

  def perform
    described_class.for(billing_period: billing_period)
  end

  describe '#perform' do
    context 'when there is only one price logic' do
      context 'with non-metered price_logic' do
        before do
          mock_non_metered_price_logic
        end

        it 'returns the correct price' do
          expect(perform[:price]).to eq(usd(100).amount)
        end

        it 'saves the details for that price logic' do
          details = perform[:details]
          expect(details.size).to eq(1)
          expect(details[0][:total_price]).to eq(usd(100).amount)
          expect(details[0][:type]).to eq('flat_fee')
        end
      end

      context 'with metered price_logic' do
        before do
          mock_metered_price_logic
        end

        it 'saves the details for that price logic' do
          details = perform[:details]
          expect(details.size).to eq(1)
          expect(details[0][:total_price]).to eq((usd(100) * 250).amount)
          expect(details[0][:type]).to eq('volume')
        end
      end
    end

    context 'when there are multiple price logic' do
      let(:price_logic_prices) { [usd(100), usd(100) * 250] }

      before do
        mock_non_metered_price_logic
        mock_metered_price_logic
      end

      it 'returns the correct price' do
        expect(perform[:price]).to eq((price_logic_prices[0] + price_logic_prices[1]).amount)
      end

      it 'saves the details for each price logic' do
        details = perform[:details]
        types = details.map { |d| d[:type] }
        total_prices = details.map { |d| d[:total_price] }

        expect(types).to match_array(['flat_fee', 'volume'])
        expect(total_prices).to match_array(price_logic_prices.map(&:amount))
      end

      context 'when billing period bills at start' do
        before do
          allow(subscription).to receive(:bills_at_start?).and_return(true)
        end

        it 'returns the correct price' do
          expected_price = (price_logic_prices[0] + price_logic_prices[1]) * 1
          expect(perform[:price]).to eq(expected_price.amount)
        end
      end
    end

    context 'when there is a permission_group' do
      let(:permission_group) { create(:permission_group, price: 1000, price_currency: 'CLP') }
      let(:subscription) do
        create(:subscription, customer: customer, permission_group: permission_group)
      end

      it 'sums the permission_group price to total amount' do
        expect(perform[:price]).to eq(clp(1000).amount)
      end

      it 'writes correct details for permission_group' do
        details = perform[:details][0]
        expect(details[:type]).to eq('Permissions')
        expect(details[:description]).to eq("Permission Group #{permission_group.name}")
        expect(details[:id]).to eq(permission_group.id)
      end
    end
  end
end
