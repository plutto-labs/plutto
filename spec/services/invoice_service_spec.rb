# rubocop:disable RSpec/MultipleMemoizedHelpers
describe InvoiceService do
  let(:kushki_service) { double }
  let(:subscription) { build(:subscription) }
  let(:billing_period) { build(:billing_period, subscription: subscription) }
  let(:invoice) do
    create(:invoice, billing_period: billing_period, customer: subscription.customer)
  end
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

  before { allow(KushkiService).to receive(:new).and_return(kushki_service) }

  describe '#send_to_customer' do
    before do
      allow(Analytics).to receive(:track).with(segment_info)
      allow(kushki_service).to receive(:enroll_link_for).with(invoice).and_return('https://link.com')
    end

    it 'send Segment event with correct data' do
      invoice.change_status!('post')
      expect(Analytics).to have_received(:track).with(segment_info)
    end
  end

  describe '#charge' do
    let(:payment_method) { create(:payment_method, customer: invoice.customer) }
    let!(:customer) { create(:customer, invoices: [invoice]) }

    before { allow(kushki_service).to receive(:charge).with(payment_method, invoice) }

    context 'when user have payment_methods' do
      let!(:payment_method) { create(:payment_method, customer: customer) }

      it 'calls charge on kushki_client' do
        invoice.change_status!('charge')
        expect(kushki_service).to have_received(:charge).with(payment_method, invoice)
      end

      context 'when payment succeeds' do
        it 'changes status to paid' do
          invoice.change_status!('charge')
          expect(invoice.status).to eq('paid')
        end
      end

      context 'when payment fails' do
        before do
          allow(kushki_service).to receive(:charge)
            .with(payment_method, invoice).and_raise(PluttoErrors::PaymentError)
        end

        it 'changes status to not_paid' do
          expect { invoice.change_status!('charge') }.to raise_error(PluttoErrors::PaymentError)

          expect(invoice.status).to eq('not_paid')
        end
      end
    end

    context 'when user does not have payment_methods' do
      before do
        customer.payment_methods.destroy_all
        allow(Analytics).to receive(:track).with(segment_info)
        allow(kushki_service).to receive(:enroll_link_for).with(invoice).and_return('https://link.com')
      end

      it 'keeps status as posted' do
        invoice.change_status!('charge')
        expect(invoice.status).to eq('posted')
      end
    end

    context 'when it is already paid' do
      before { invoice.update(status: 'paid') }

      it 'raises PluttoErrors:InvalidTransition error' do
        expect { invoice.change_status!('charge') }.to raise_error(PluttoErrors::InvalidTransition)
      end
    end
  end

  describe '#void' do
    it 'changes status to voided' do
      invoice.change_status!('void')
      expect(invoice.status).to eq('voided')
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
