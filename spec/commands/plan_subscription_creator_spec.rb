require 'rails_helper'

describe PlanSubscriptionCreator do
  let(:customer) { build(:customer) }
  let(:plan_version) { build(:plan_version) }

  def perform
    described_class.for(customer: customer, plan_version: plan_version)
  end

  describe '#perform' do
    it 'creates a new subscription' do
      expect { perform }.to change { customer.plan_subscriptions.count }.by(1)
    end

    it 'creates a new subscription with active status' do
      plan_subscription = perform
      expect(plan_subscription.active).to be_truthy
    end

    context 'when there is a previous active subscription' do
      let!(:plan_subscription) { create(:plan_subscription, customer: customer, active: true) }
      let(:plan_subscription_service) { instance_double(PlanSubscriptionService) }

      before do
        allow(PlanSubscriptionService).to receive(:new).with(plan_subscription: plan_subscription)
                                                       .and_return(plan_subscription_service)
        allow(plan_subscription_service).to receive(:end_billing_period)
          .with(start_new_period: false)
      end

      it 'changes the previous plan_subscription to inactive' do
        expect { perform }.to change { plan_subscription.reload.active }.from(true).to(false)
      end

      it 'call PlanSubscriptionService to end the current billing period' do
        perform
        expect(plan_subscription_service).to have_received(:end_billing_period)
          .with(start_new_period: false)
      end
    end
  end
end
