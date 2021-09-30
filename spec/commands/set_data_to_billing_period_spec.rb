require 'rails_helper'

describe SetDataToBillingPeriod do
  let(:count_type) { 'initial_count' }
  let(:meters) { create_list(:meter, 3) }
  let!(:subscription) { create(:subscription) }
  let!(:billing_period) { create(:billing_period, subscription: subscription) }

  def perform
    described_class.for(billing_period: billing_period, count_type: count_type)
  end

  describe '#perform' do
    context 'when it has metered price logics' do
      before do
        products = [create(:product, meter: meters[0]), create(:product, meter: meters[1]),
                    create(:product, meter: meters[2])]
        pricings = [create(:pricing, product: products[0]), create(:pricing, product: products[1]),
                    create(:pricing, product: products[2])]

        create(:price_logic_per_unit, pricing: pricings[0])
        create(:price_logic_per_unit, pricing: pricings[1])
        create(:price_logic_per_unit, pricing: pricings[2])
        create(:pricing_subscription, pricing: pricings[0], subscription: subscription)
        create(:pricing_subscription, pricing: pricings[1], subscription: subscription)
        create(:pricing_subscription, pricing: pricings[2], subscription: subscription)

        subscription.reload
      end

      context 'when it has not repeated meters' do
        it { expect { perform }.to change { BillingPeriodMeterData.count }.by(3) }

        context 'when count type is initial_count'
        it 'calls update with correct params'

        context 'when count type is final_count'
        it 'calls update with correct params'

        context 'when count type is not valid'
        it 'not call update'

        context 'when it has not meter counts created' do
          it 'creates a meter count for each one' do
            expect { perform }.to change { MeterCount.count }.by(3)
          end
        end

        context 'when it has meter counts created' do
          before do
            create(:meter_count, customer: subscription.customer, meter: subscription.pricings[0].meter)
          end

          it 'only creates necessary meter counts' do
            expect { perform }.to change { MeterCount.count }.by(2)
          end
        end
      end

      context 'when it has repeated meters' do
        let(:meter) { create(:meter) }
        let(:meters) { [meter, meter, create(:meter)] }

        before do
          create(:price_logic_per_unit, pricing: subscription.pricings[0])
          create(:price_logic_per_unit, pricing: subscription.pricings[1])
          create(:price_logic_per_unit, pricing: subscription.pricings[2])
        end

        it { expect { perform }.to change { BillingPeriodMeterData.count }.by(2) }

        context 'when it has not meter counts created' do
          it 'creates a meter count for each one' do
            expect { perform }.to change { MeterCount.count }.by(2)
          end
        end

        context 'when it has meter counts created' do
          before do
            create(:meter_count, customer: subscription.customer, meter: Meter.first)
          end

          it 'only creates necessary meter counts' do
            expect { perform }.to change { MeterCount.count }.by(1)
          end
        end
      end
    end

    context 'when it has no metered price logics' do
      before do
        product = create(:product, meter: meters[0])
        pricing = create(:pricing, product: product)

        create(:price_logic_flat_fee, pricing: pricing)
        create(:pricing_subscription, pricing: pricing, subscription: subscription)
      end

      it 'does not create any meter counts' do
        expect { perform }.to change { MeterCount.count }.by(0)
      end
    end
  end
end
