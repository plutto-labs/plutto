RSpec.describe ChangeInvoiceStatusJob, type: :job do
  let!(:invoice) { create(:invoice) }
  let!(:status) { 'post' }

  before do
    allow(invoice).to receive(:change_status!).with(status)
  end

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class).once
    end

    it 'calls invoice.change_status!' do
      described_class.perform_now(invoice, status)
      expect(invoice).to have_received(:change_status!).with(status)
    end
  end
end
