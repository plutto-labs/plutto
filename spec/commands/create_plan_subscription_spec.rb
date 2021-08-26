require 'rails_helper'

describe CreatePlanSubscription do
  let(:customer) { build(:customer) }
  let(:plan_version) { build(:plan_version) }

  def perform
    described_class.for(customer: customer, plan_version: plan_version)
  end

  describe '#perform' do
    let(:new_plan_subscription_service) do
      instance_double(PlanSubscriptionService, initialize_next_billing_period: true)
    end

    before do
      allow(PlanSubscriptionService).to receive(:new).and_return(new_plan_subscription_service)
    end

    it 'creates a new subscription' do
      expect { perform }.to change { customer.plan_subscriptions.count }.by(1)
    end

    it 'creates a new subscription with active status' do
      plan_subscription = perform
      expect(plan_subscription.active).to be_truthy
    end

    it 'returns the new PlanSubscription' do
      expect(perform).to be_a(PlanSubscription)
    end

    it 'call PlanSubscriptionService to end the start next billing period' do
      perform
      expect(new_plan_subscription_service).to have_received(:initialize_next_billing_period)
    end

    context 'when there is a previous active subscription' do
      let!(:plan_subscription) { create(:plan_subscription, customer: customer, active: true) }
      let(:plan_subscription_service) do
        instance_double(PlanSubscriptionService, end_billing_period: true)
      end

      before do
        allow(PlanSubscriptionService).to receive(:new)
          .and_return(plan_subscription_service, new_plan_subscription_service)
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
