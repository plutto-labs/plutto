require 'rails_helper'

describe CreateInvoice do
  let(:billing_period) { build(:billing_period) }

  def perform
    described_class.for(billing_period: billing_period)
  end

  describe '#perform' do
    before do
      allow(BillingPeriodPriceDetails).to receive(:for).and_return(usd(100))
      Timecop.freeze
    end

    it 'creates a invoice for the billing period' do
      expect { perform }.to change { Invoice.count }.by(1)
    end

    it 'gets the current billing amount' do
      perform

      expect(BillingPeriodPriceDetails).to have_received(:for)
    end

    it 'saves the subtotal amount' do
      invoice = perform
      expect(invoice.subtotal).to eq(usd(100))
    end

    it 'saves the taxes amount'

    it 'saves the discount amount'

    it 'sets the issue date' do
      invoice = perform
      expect(invoice.issue_date).to eq(DateTime.current)
    end
  end
end
