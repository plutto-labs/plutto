require 'rails_helper'

describe BillingPeriodPriceCalculator do
  let(:meter_counts) { [] }
  let(:days_in_periods) { 30 }
  let(:plan_version) { build(:plan_version) }
  let(:plan_subscription) { build(:plan_subscription, plan_version: plan_version) }

  def perform
    described_class.for(meter_counts: meter_counts, plan_subscription: plan_subscription,
                        total_period_days: 30, days_in_periods: days_in_periods)
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
      let(:meter) { build(:meter) }
      let!(:meter_counts) { [create(:meter_count, meter: meter, count: 250)] }

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

        it 'returns the correct price' do
          expected_price = (usd(100) * 250 + usd(100)) * 0.5
          expect(perform).to eq(expected_price)
        end
      end
    end
  end
end
