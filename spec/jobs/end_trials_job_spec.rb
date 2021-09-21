require 'rails_helper'

RSpec.describe EndTrialsJob, type: :job do
  let!(:plan_subscription1) do
    create(
      :plan_subscription,
      trial_finishes_at: Date.current - 1.day
    )
  end
  let!(:plan_subscription2) do
    create(
      :plan_subscription,
      trial_finishes_at: Date.current
    )
  end
  let!(:plan_subscription3) do
    create(
      :plan_subscription,
      trial_finishes_at: Date.current + 1.day
    )
  end

  before do
    allow(EndTrialJob).to receive(:perform_later).with(plan_subscription1)
    allow(EndTrialJob).to receive(:perform_later).with(plan_subscription2)
    allow(EndTrialJob).to receive(:perform_later).with(plan_subscription3)
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class).once
    end
  end

  describe '#perform_now' do
    it 'calls end_billing_period_job only with subscription 1' do
      described_class.perform_now
      expect(EndTrialJob).to have_received(:perform_later)
        .with(plan_subscription1).once
      expect(EndTrialJob).not_to have_received(:perform_later)
        .with(plan_subscription2)
      expect(EndTrialJob).not_to have_received(:perform_later)
        .with(plan_subscription3)
    end
  end
end
