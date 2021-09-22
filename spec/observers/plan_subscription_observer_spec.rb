require 'rails_helper'

describe PlanSubscriptionObserver do
  let(:plan_subscription) { build(:plan_subscription) }

  def trigger(type, event)
    described_class.trigger(type, event, plan_subscription)
  end

  describe '#after_create' do
    before do
      allow(StartNewBillingPeriod).to receive(:for).with(
        plan_subscription: plan_subscription,
        billing_period: nil
      )
    end

    context 'when subscription is not in trial' do
      before do
        allow(plan_subscription).to receive(:in_trial?).and_return(false)
      end

      it 'calls correct command' do
        trigger :after, :create
        expect(StartNewBillingPeriod).to have_received(:for).with(
          plan_subscription: plan_subscription,
          billing_period: nil
        )
      end
    end

    context 'when subscription is in trial' do
      before do
        allow(plan_subscription).to receive(:in_trial?).and_return(true)
      end

      it 'dont do anything' do
        trigger :after, :create
        expect(StartNewBillingPeriod).not_to have_received(:for).with(
          plan_subscription: plan_subscription,
          billing_period: nil
        )
      end
    end
  end
end
