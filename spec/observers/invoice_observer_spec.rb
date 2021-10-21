describe InvoiceObserver do
  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, organization: organization) }
  let(:invoice) { create(:invoice, customer: customer) }
  let(:invoice_service) { double }

  def trigger(type, event)
    described_class.trigger(type, event, invoice)
  end

  describe '#after_create' do
    before do
      allow(InvoiceService).to receive(:new).with(invoice: invoice).and_return(invoice_service)
    end

    context 'when charge_invoices_automatically is true' do
      before do
        allow(invoice_service).to receive(:charge!)
        organization.settings['charge_invoices_automatically'] = true
        organization.save!
      end

      it 'attemps to charge invoice' do
        invoice.reload
        trigger :after, :create
        expect(invoice_service).to have_received(:charge!)
      end
    end

    context 'when charge_invoices_automatically is false' do
      before do
        allow(invoice_service).to receive(:post!)
        organization.settings['charge_invoices_automatically'] = false
        organization.save!
      end

      it 'attemps to post invoice if send_invoices_automatically is true' do
        organization.settings['send_invoices_automatically'] = true
        organization.save!
        trigger :after, :create
        expect(invoice_service).to have_received(:post!)
      end

      it 'does not attemp to post invoice if send_invoices_automatically is false' do
        organization.settings['send_invoices_automatically'] = false
        organization.save!
        trigger :after, :create
        expect(invoice_service).not_to have_received(:post!)
      end
    end
  end
end
