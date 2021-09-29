describe InvoiceService do
  let(:kushki) { double }
  let(:plan_subscription) { build(:plan_subscription) }
  let(:billing_period) { build(:billing_period, plan_subscription: plan_subscription) }
  let(:invoice) do
    build(:invoice, billing_period: billing_period, customer: plan_subscription.customer)
  end

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
      allow(KushkiService).to receive(:new).and_return(kushki)
      allow(kushki).to receive(:enroll_link_for).with(invoice.customer).and_return('https://link.com')
    end

    it 'send Segment event with correct data' do
      invoice.send_to_customer
      expect(Analytics).to have_received(:track).with(segment_info)
    end
  end
end
