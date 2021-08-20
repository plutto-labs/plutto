require 'rails_helper'

describe StartBillingPeriod do
  let(:plan_version) { build(:plan_version) }
  let(:plan_subscription) { build(:plan_subscription, plan_version: plan_version) }
  let(:billing_period) { build(:billing_period, plan_subscription: plan_subscription) }

  def perform
    described_class.for(billing_period: billing_period)
  end

  describe '#perform' do
    context 'when it has metered price logics' do
      let(:metered_price_logics) { 3 }
      let!(:price_logics) do
        create_list(:price_logic_per_unit, metered_price_logics, plan_version: plan_version)
      end

      it 'creates a meter count for each one' do
        expect { perform }.to change { MeterCount.count }.by(metered_price_logics)
      end
    end

    context 'when it has no metered price logics' do
      let!(:price_logic) { create(:price_logic_flat_fee, plan_version: plan_version) }

      it 'does not create any meter counts' do
        expect { perform }.to change { MeterCount.count }.by(0)
      end
    end
  end
end
