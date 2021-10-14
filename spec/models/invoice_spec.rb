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
      allow(invoice.aasm).to receive(:fire!)
      allow(InvoiceService).to receive(:new).and_return(invoice_service)
    end

    it 'calls fire! method from aasm' do
      invoice.change_status('paid')
      expect(invoice.aasm).to have_received(:fire!)
    end

    describe 'post' do
      before { allow(invoice_service).to receive(:send_to_customer).with(invoice) }

      it 'calls invoice_service.send_to_customer' do
        invoice.post!
        expect(invoice_service).to have_received(:send_to_customer).with(invoice)
      end
    end

    describe 'charge' do
      let!(:customer) { create(:customer, invoices: [invoice]) }
      let!(:payment_method) { create(:payment_method, customer: customer) }

      before do
        allow(invoice_service).to receive(:charge).with(invoice, payment_method)
        invoice.status = 'posted'
      end

      context 'when user have payment_methods' do
        it 'calls invoice_service.charge' do
          invoice.charge!
          expect(invoice_service).to have_received(:charge).with(invoice, payment_method)
        end
      end

      context 'when user does not have payment_methods' do
        it 'calls invoice_service.charge' do
          customer.payment_methods.destroy_all
          expect { invoice.charge! }.to raise_error(ApiException::Errors::UnprocessableEntity)
          expect(invoice_service).not_to have_received(:charge)
        end
      end
    end
  end
end
