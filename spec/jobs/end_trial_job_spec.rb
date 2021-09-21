require 'rails_helper'

RSpec.describe EndTrialJob, type: :job do
  let(:trial_finishes_at) { Date.current - 1.day }
  let!(:plan_subscription) do
    create(
      :plan_subscription,
      trial_finishes_at: trial_finishes_at
    )
  end

  before do
    allow(StartNewBillingPeriod).to receive(:for).with(
      plan_subscription: plan_subscription,
      billing_period: nil
    )
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class).once
    end
  end

  describe '#perform_now' do
    it 'calls end_billing_period_job' do
      described_class.perform_now(plan_subscription)
      expect(StartNewBillingPeriod).to have_received(:for)
        .with(
          plan_subscription: plan_subscription,
          billing_period: nil
        ).once
    end

    it 'change trial_finishes_at' do
      expect do
        described_class.perform_now(plan_subscription)
      end.to change { plan_subscription.trial_finishes_at }.from(trial_finishes_at).to(nil)
    end
  end
end
