require 'rails_helper'

describe AddPricingsToSubscription do
  let(:poduct) { create(:product) }
  let(:pricing) { create(:pricing, product: poduct) }
  let(:pricings) { [pricing, create(:pricing)] }
  let(:subscription) { create(:subscription, active: true) }

  def perform(pricings)
    described_class.for(pricings: pricings, subscription: subscription)
  end

  describe '#perform' do
    context 'when no pricings are given' do
      it 'does not add any pricings' do
        expect { perform([]) }.not_to (change { subscription.pricings.count })
      end
    end

    context 'when subscription is inactive' do
      let(:subscription) { create(:subscription, active: false) }

      it 'raises an error' do
        expect { perform(pricings) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when pricings have repeated products' do
      let(:repeated_pricing) { create(:pricing, product: poduct) }
      let(:pricings) { [pricing, repeated_pricing] }

      it 'raise a bad request error' do
        expect { perform(pricings) }.to raise_error(ApiException::Errors::UnprocessableEntity)
      end
    end

    context 'when pricings have unique products' do
      context 'when subscription has already one of this products' do
        before do
          create(:pricing_subscription, subscription: subscription, pricing: pricing)
        end

        it 'raise a bad request error' do
          expect { perform(pricings) }.to raise_error(ApiException::Errors::UnprocessableEntity)
        end
      end

      context 'when subscription has no one of this products' do
        it 'adds the pricings to the subscription' do
          expect { perform(pricings) }.to change { subscription.pricings.count }.by(2)
        end
      end
    end

    context 'when pricings have different currencies' do
      let(:pricings) { [create(:pricing, currency: 'CLP'), create(:pricing, currency: 'USD')] }

      it 'raise a bad request error' do
        expect { perform(pricings) }.to raise_error(ApiException::Errors::UnprocessableEntity)
      end
    end
  end
end
