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

    context 'when there is an previous active subscription' do
      let!(:plan_subscription) { create(:plan_subscription, customer: customer, active: true) }

      it 'changes the previous plan_subscription to inactive' do
        expect { perform }.to change { plan_subscription.reload.active }.from(true).to(false)
      end
    end
  end
end
