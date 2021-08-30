require 'rails_helper'

describe BillingPeriodPriceCalculator do
  let(:customer) { create(:customer) }
  let(:from) { Time.current }
  let(:to) { Time.current + 30.days }
  let(:billing_date) { to }
  let(:plan_version) { create(:plan_version) }
  let(:plan_subscription) do
    create(:plan_subscription, plan_version: plan_version, customer: customer)
  end
  let(:billing_period) do
    create(
      :billing_period,
      from: from,
      to: to,
      plan_subscription: plan_subscription,
      billing_date: billing_date
    )
  end

  def perform
    described_class.for(billing_period: billing_period)
  end

  describe '#perform' do
    before do
      price_logic = create(:price_logic_flat_fee, price: usd(100), plan_version: plan_version)
      allow(price_logic).to receive(:calculate_price).with(250).and_return(usd(100))
    end

    context 'when there is only one price logic' do
      it 'returns the correct price' do
        expect(perform).to eq(usd(100))
      end
    end

    context 'when there are multiple price logic' do
      let(:meter) { create(:meter, meter_type: 'period_sum') }
      let!(:meter_count) { create(:meter_count, meter: meter, count: 250, customer: customer) }
      let!(:billing_period_meter_data) do
        create(
          :billing_period_meter_data,
          initial_count: 10,
          final_count: 260,
          billing_period: billing_period,
          meter_count: meter_count
        )
      end

      before do
        tiers_params = [{ price: usd(300), limit: 100 }, { price: usd(200), limit: 200 },
                        { price: usd(100), limit: 300 }]

        price_logic = create(:price_logic_volume, :with_tiers,
                             price: usd(100), tiers_params: tiers_params,
                             plan_version: plan_version, meter: meter)

        allow(price_logic).to receive(:calculate_price).with(250).and_return(usd(100))
      end

      it 'returns the correct price' do
        expected_price = usd(100) * 250 + usd(100)
        expect(perform).to eq(expected_price)
      end

      context 'when billing period end before the end of period' do
        let(:days_in_periods) { 15 }
        let(:billing_date) { Time.current + 15.days }

        it 'returns the correct price' do
          expected_price = (usd(100) * 250 + usd(100)) * 0.5
          expect(perform).to eq(expected_price)
        end
      end
    end
  end
end
