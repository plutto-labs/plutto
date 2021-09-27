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
    describe '#set_currency' do
      let(:billing_period) { create(:billing_period) }
      let(:invoice) { create(:invoice, billing_period: billing_period) }

      before do
        allow(billing_period.plan_subscription.plan_version)
          .to receive(:currency).and_return('CLP')
      end

      it 'sets the currency from plans currency' do
        invoice.save
        expect(invoice.currency).to eq('CLP')
      end
    end

    describe '#set_invoice_data' do
      let(:billing_period) { create(:billing_period) }
      let(:invoice) do
        build(:invoice, billing_period: billing_period, subtotal_cents: 1000,
                        discount_cents: 100)
      end

      before do
        allow(billing_period.plan_subscription.plan_version.plan)
          .to receive(:tax_rate).and_return(0.19)
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

    before { allow(invoice.aasm).to receive(:fire!) }

    it 'calls fire! method from aasm' do
      invoice.change_status('paid')
      expect(invoice.aasm).to have_received(:fire!)
    end
  end
end
