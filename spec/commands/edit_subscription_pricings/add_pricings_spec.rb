require 'rails_helper'

describe EditSubscriptionPricings::AddPricings do
  let(:product) { create(:product) }
  let(:pricing) { create(:pricing, product: product) }
  let(:pricings) { [pricing, create(:pricing)] }
  let(:subscription) { create(:subscription, active: true) }

  def perform(pricings)
    described_class.for(pricings: pricings, subscription: subscription)
  end

  describe '#perform' do
    context 'when pricings have unique products' do
      context 'when subscription has already one of this products' do
        before do
          create(:pricing_subscription,
                 subscription: subscription,
                 pricing: create(:pricing, product: product))
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

    context 'when pricings have repeated products' do
      let(:repeated_pricing) { create(:pricing, product: product) }
      let(:pricings) { [pricing, repeated_pricing] }

      it 'adds only product once for first pricing' do
        expect { perform(pricings) }.to raise_error(ApiException::Errors::UnprocessableEntity)
      end
    end

    context 'when pricings have different currencies' do
      let(:subscription) { create(:subscription, active: true, currency: 'USD') }
      let(:pricings) { [create(:pricing, currency: 'CLP'), create(:pricing, currency: 'USD')] }

      it 'raise a bad request error' do
        expect { perform(pricings) }.to raise_error(ApiException::Errors::UnprocessableEntity)
      end
    end

    it_behaves_like 'edit subscription command'
  end
end
