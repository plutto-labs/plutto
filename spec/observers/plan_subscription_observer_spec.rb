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

    it 'calls correct command' do
      trigger :after, :create
      expect(StartNewBillingPeriod).to have_received(:for).with(
        plan_subscription: plan_subscription,
        billing_period: nil
      )
    end
  end
end
