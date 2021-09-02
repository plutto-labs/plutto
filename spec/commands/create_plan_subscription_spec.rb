require 'rails_helper'

describe CreatePlanSubscription do
  let(:customer) { create(:customer) }
  let(:plan_version) { create(:plan_version) }
  let(:plan_subscription) do
    create(
      :plan_subscription,
      plan_version: plan_version,
      customer: customer,
      active: true
    )
  end
  let(:billing_period) { create(:billing_period, plan_subscription: plan_subscription) }

  def perform
    described_class.for(customer: customer, plan_version: plan_version)
  end

  describe '#perform' do
    before do
      allow(EndBillingPeriod).to receive(:for)
        .with(
          billing_period: billing_period,
          start_next_period: false
        )
        .and_return(true)
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

    context 'when there is a previous active subscription' do
      it 'changes the previous plan_subscription to inactive' do
        expect { perform }.to change { plan_subscription.reload.active }.from(true).to(false)
      end

      it 'call EndBillingPeriod to end the current billing period' do
        perform
        expect(EndBillingPeriod).to have_received(:for)
          .with(
            billing_period: billing_period,
            start_next_period: false
          )
      end
    end
  end
end
