require 'rails_helper'

RSpec.describe EndBillingPeriodsJob, type: :job do
  let!(:billing_period1) do
    create(
      :billing_period,
      to: Date.current - 1.day,
      billing_date: nil
    )
  end
  let!(:billing_period2) do
    create(
      :billing_period,
      to: Date.current,
      billing_date: nil
    )
  end
  let!(:billing_period3) do
    create(
      :billing_period,
      to: Date.current - 1.day,
      billing_date: Date.current
    )
  end

  before do
    allow(EndBillingPeriodJob).to receive(:perform_later).with(billing_period1)
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class).once
    end
  end

  describe '#perform_now' do
    it 'calls end_billing_period_job' do
      described_class.perform_now
      expect(EndBillingPeriodJob).to have_received(:perform_later)
        .with(billing_period1).once
    end
  end
end
