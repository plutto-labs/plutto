# rubocop:disable RSpec/MultipleMemoizedHelpers
require 'rails_helper'

describe CreatePlanSubscription do
  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, organization: organization) }
  let(:plan) { create(:plan, organization: organization) }
  let(:previous_plan_version) { create(:plan_version, plan: plan) }
  let(:plan_subscription) do
    create(
      :plan_subscription,
      plan_version: previous_plan_version,
      customer: customer,
      active: true
    )
  end
  let(:billing_period) { create(:billing_period, plan_subscription: plan_subscription) }
  let(:plan_version) { create(:plan_version, plan: plan) }

  def perform(plan_version)
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
      expect { perform(plan_version) }.to change { customer.plan_subscriptions.count }.by(1)
    end

    it 'creates a new subscription with active status' do
      plan_subscription = perform(plan_version)
      expect(plan_subscription.active).to be_truthy
    end

    it 'returns the new PlanSubscription' do
      expect(perform(plan_version)).to be_a(PlanSubscription)
    end

    context 'when there is a previous active subscription' do
      it 'changes the previous plan_subscription to inactive' do
        expect { perform(plan_version) }.to change {
          plan_subscription.reload.active
        }.from(true).to(false)
      end

      it 'call EndBillingPeriod to end the current billing period' do
        perform(plan_version)
        expect(EndBillingPeriod).to have_received(:for)
          .with(
            billing_period: billing_period,
            start_next_period: false
          )
      end

      context 'when the previous plan version is equal to the new one' do
        it do
          expect do
            perform(previous_plan_version)
          end.to raise_error(ActiveModel::ForbiddenAttributesError)
        end
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
