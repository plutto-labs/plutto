describe InvoiceObserver do
  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, organization: organization) }
  let(:invoice) { create(:invoice, customer: customer) }

  def trigger(type, event)
    described_class.trigger(type, event, invoice)
  end

  describe '#after_create' do
    context 'when charge_invoices_automatically is true' do
      before do
        allow(ChangeInvoiceStatusJob).to receive(:perform_later).with(invoice, 'charge')
        organization.settings['charge_invoices_automatically'] = true
        organization.save!
      end

      it 'attemps to charge invoice' do
        invoice.reload
        trigger :after, :create
        expect(ChangeInvoiceStatusJob).to have_received(:perform_later).with(invoice, 'charge')
      end
    end

    context 'when charge_invoices_automatically is false' do
      before do
        allow(ChangeInvoiceStatusJob).to receive(:perform_later).with(invoice, 'post')
        organization.settings['charge_invoices_automatically'] = false
        organization.save!
      end

      it 'attemps to post invoice if send_invoices_automatically is true' do
        organization.settings['send_invoices_automatically'] = true
        organization.save!
        trigger :after, :create
        expect(ChangeInvoiceStatusJob).to have_received(:perform_later).with(invoice, 'post')
      end

      it 'does not attemp to post invoice if send_invoices_automatically is false' do
        organization.settings['send_invoices_automatically'] = false
        organization.save!
        trigger :after, :create
        expect(ChangeInvoiceStatusJob).not_to have_received(:perform_later).with(invoice, 'post')
      end
    end
  end
end
