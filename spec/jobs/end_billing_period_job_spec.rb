require 'rails_helper'

RSpec.describe EndBillingPeriodJob, type: :job do
  let!(:billing_period) do
    create(
      :billing_period,
      to: Date.current,
      billing_date: nil
    )
  end

  before do
    allow(EndBillingPeriod).to receive(:for).with(billing_period: billing_period)
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class).once
    end
  end

  describe '#perform_now' do
    it 'calls end_billing_period_job' do
      described_class.perform_now(billing_period)
      expect(EndBillingPeriod).to have_received(:for)
        .with(billing_period: billing_period).once
    end
  end
end
