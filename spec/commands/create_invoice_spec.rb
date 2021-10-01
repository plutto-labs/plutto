require 'rails_helper'

describe CreateInvoice do
  let(:customer) { create(:customer) }
  let(:subscription) { create(:subscription, customer: customer, currency: 'CLP') }
  let(:billing_period) { create(:billing_period, subscription: subscription) }

  def perform
    described_class.for(billing_period: billing_period, customer: customer)
  end

  describe '#perform' do
    let(:response) do
      {
        price: 100, details: {}
      }.with_indifferent_access
    end

    before do
      allow(BillingPeriodPriceDetails).to receive(:for).and_return(response)
      Timecop.freeze
    end

    it 'creates a invoice for the billing period' do
      expect { perform }.to change { Invoice.count }.by(1)
    end

    it 'gets the current billing amount' do
      perform

      expect(BillingPeriodPriceDetails).to have_received(:for)
    end

    it 'saves the currency correctly' do
      invoice = perform
      expect(invoice.currency).to eq('CLP')
    end

    it 'saves the subtotal amount' do
      invoice = perform
      expect(invoice.subtotal).to eq(clp(100))
    end

    it 'saves the taxes amount'

    it 'saves the discount amount'

    it 'sets the issue date' do
      invoice = perform
      expect(invoice.issue_date).to eq(DateTime.current)
    end
  end
end
