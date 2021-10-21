require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'Relations' do
    let(:invoice) { create(:invoice) }

    it { expect(invoice).to belong_to(:billing_period) }
    it { expect(invoice).to belong_to(:customer) }
  end

  it { is_expected.to monetize(:subtotal_cents).with_model_currency(:currency) }
  it { is_expected.to monetize(:tax_cents).with_model_currency(:currency) }
  it { is_expected.to monetize(:discount_cents).with_model_currency(:currency) }

  describe 'Callbacks' do
    describe '#set_invoice_data' do
      let(:billing_period) { create(:billing_period) }
      let(:invoice) do
        build(:invoice, billing_period: billing_period, subtotal_cents: 1000,
                        discount_cents: 100)
      end

      before do
        allow(billing_period.subscription).to receive(:tax_rate).and_return(0.19)
      end

      it 'sets the invoice data' do
        invoice.save
        expect(invoice.net_cents).to eq(900)
        expect(invoice.tax_cents).to eq(171)
        expect(invoice.total_cents).to eq(1071)
      end
    end
  end

  describe '#change_status' do
    let(:invoice) { create(:invoice) }
    let(:invoice_service) { double }

    before do
      allow(InvoiceService).to receive(:new).with(invoice: invoice).and_return(invoice_service)
      allow(invoice_service).to receive(:post!)
      allow(invoice_service).to receive(:charge!)
    end

    it 'calls invoice_service.post' do
      invoice.change_status('post')
      expect(invoice_service).to have_received(:post!)
    end

    it 'calls invoice_service.charge' do
      invoice.change_status('charge')
      expect(invoice_service).to have_received(:charge!)
    end
  end
end
