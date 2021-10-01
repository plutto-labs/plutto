require 'rails_helper'

describe EditSubscriptionPricings::RemovePricings do
  let(:poduct) { create(:product) }
  let(:pricings) { create_list(:pricing, 2) }
  let(:subscription) { create(:subscription, active: true) }

  def perform(pricings)
    described_class.for(pricings: pricings, subscription: subscription)
  end

  describe '#perform' do
    context 'with previously pricings suscribed' do
      before do
        create(:pricing_subscription, subscription: subscription, pricing: pricings[0])
        create(:pricing_subscription, subscription: subscription, pricing: pricings[1])
      end

      it 'removes correct pricing subscription' do
        perform([pricings[0]])
        expect(subscription.pricings).to include(pricings[1])
      end
    end

    context 'when the subscription is not subscribed' do
      before { create(:pricing_subscription, subscription: subscription) }

      it 'not change subscirption.pricings' do
        expect { perform(pricings) }.not_to (change { subscription.pricings })
      end
    end

    it_behaves_like 'edit subscription command'
  end
end
