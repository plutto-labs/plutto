require 'rails_helper'

describe SubscriptionObserver do
  let(:subscription) { build(:subscription) }

  def trigger(type, event)
    described_class.trigger(type, event, subscription)
  end

  describe '#after_create' do
    before do
      allow(StartNewBillingPeriod).to receive(:for).with(
        subscription: subscription,
        billing_period: nil
      )
    end

    context 'when subscription is not in trial' do
      before do
        allow(subscription).to receive(:in_trial?).and_return(false)
      end

      it 'calls correct command' do
        trigger :after, :create
        expect(StartNewBillingPeriod).to have_received(:for).with(
          subscription: subscription,
          billing_period: nil
        )
      end
    end

    context 'when subscription is in trial' do
      before do
        allow(subscription).to receive(:in_trial?).and_return(true)
      end

      it 'dont do anything' do
        trigger :after, :create
        expect(StartNewBillingPeriod).not_to have_received(:for).with(
          subscription: subscription,
          billing_period: nil
        )
      end
    end
  end
end
