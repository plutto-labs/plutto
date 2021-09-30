require 'rails_helper'

RSpec.describe EndTrialsJob, type: :job do
  let!(:subscription1) do
    create(
      :subscription,
      trial_finishes_at: Date.current - 1.day
    )
  end
  let!(:subscription2) do
    create(
      :subscription,
      trial_finishes_at: Date.current
    )
  end
  let!(:subscription3) do
    create(
      :subscription,
      trial_finishes_at: Date.current + 1.day
    )
  end

  before do
    allow(EndTrialJob).to receive(:perform_later).with(subscription1)
    allow(EndTrialJob).to receive(:perform_later).with(subscription2)
    allow(EndTrialJob).to receive(:perform_later).with(subscription3)
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
        .with(subscription1).once
      expect(EndTrialJob).not_to have_received(:perform_later)
        .with(subscription2)
      expect(EndTrialJob).not_to have_received(:perform_later)
        .with(subscription3)
    end
  end
end
