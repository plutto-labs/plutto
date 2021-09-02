require 'rails_helper'

describe SetInitialDataToBillingPeriod do
  let(:customer) { create(:customer) }
  let(:plan_version) { build(:plan_version) }
  let(:plan_subscription) do
    build(:plan_subscription, plan_version: plan_version, customer: customer)
  end
  let(:billing_period) { build(:billing_period, plan_subscription: plan_subscription) }

  def perform
    described_class.for(billing_period: billing_period)
  end

  describe '#perform' do
    context 'when it has metered price logics' do
      context 'when it has not repeated meters' do
        before do
          meter1 = create(:meter)
          meter2 = create(:meter)
          meter3 = create(:meter)
          create(:price_logic_per_unit, plan_version: plan_version, meter: meter1)
          create(:price_logic_per_unit, plan_version: plan_version, meter: meter2)
          create(:price_logic_per_unit, plan_version: plan_version, meter: meter3)
        end

        it { expect { perform }.to change { BillingPeriodMeterData.count }.by(3) }

        context 'when it has not meter counts created' do
          it 'creates a meter count for each one' do
            expect { perform }.to change { MeterCount.count }.by(3)
          end
        end

        context 'when it has price counts created' do
          before do
            create(:meter_count, customer: customer, meter: Meter.first)
          end

          it 'only creates necessary meter counts' do
            expect { perform }.to change { MeterCount.count }.by(2)
          end
        end
      end

      context 'when it has repeated meters' do
        before do
          meter1 = create(:meter)
          meter2 = create(:meter)
          create(:price_logic_per_unit, plan_version: plan_version, meter: meter1)
          create(:price_logic_per_unit, plan_version: plan_version, meter: meter2)
          create(:price_logic_per_unit, plan_version: plan_version, meter: meter2)
        end

        it { expect { perform }.to change { BillingPeriodMeterData.count }.by(2) }

        context 'when it has not meter counts created' do
          it 'creates a meter count for each one' do
            expect { perform }.to change { MeterCount.count }.by(2)
          end
        end

        context 'when it has meter counts created' do
          before do
            create(:meter_count, customer: customer, meter: Meter.first)
          end

          it 'only creates necessary meter counts' do
            expect { perform }.to change { MeterCount.count }.by(1)
          end
        end
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
