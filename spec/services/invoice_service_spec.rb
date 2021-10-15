describe InvoiceService do
  let(:kushki_service) { double }
  let(:subscription) { build(:subscription) }
  let(:billing_period) { build(:billing_period, subscription: subscription) }
  let(:invoice) do
    create(:invoice, billing_period: billing_period, customer: subscription.customer)
  end

  before { allow(KushkiService).to receive(:new).and_return(kushki_service) }

  describe '#send_to_customer' do
    let(:segment_info) do
      { user_id: invoice.customer.organization_id,
        event: 'send invoice',
        properties: {
          invoice_date: invoice.issue_date,
          invoice_total: { amount: invoice.subtotal.amount, currency: invoice.currency },
          details: invoice.details,
          customer_email: invoice.customer.email,
          customer_name: invoice.customer.name,
          customer_organization: invoice.customer.organization.name,
          billing_information: invoice.customer.billing_information.serializable_hash,
          payment_link: 'https://link.com'
        } }
    end

    before do
      allow(Analytics).to receive(:track).with(segment_info)
      allow(kushki_service).to receive(:enroll_link_for).with(invoice).and_return('https://link.com')
    end

    it 'send Segment event with correct data' do
      invoice.send_to_customer
      expect(Analytics).to have_received(:track).with(segment_info)
    end
  end

  describe '#charge' do
    let(:payment_method) { create(:payment_method, customer: invoice.customer) }

    before { allow(kushki_service).to receive(:charge).with(payment_method, invoice) }

    it 'calls charge on kushki_client' do
      invoice.charge_customer(invoice.customer.payment_methods.first)
      expect(kushki_service).to have_received(:charge).with(payment_method, invoice)
    end
  end
end
