require 'rails_helper'

describe CreateInvoice do
  let(:customer) { create(:customer) }
  let(:plan_subscription) { create(:plan_subscription, customer: customer) }
  let(:billing_period) { create(:billing_period, plan_subscription: plan_subscription) }

  def perform
    described_class.for(billing_period: billing_period, customer: customer)
  end

  describe '#perform' do
    let(:response) do
      {
        price: { cents: 100 }, details: {}
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
