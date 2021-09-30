require 'rails_helper'

describe InvoiceObserver do
  let(:subscription) { build(:subscription, auto_collection: auto_collection) }
  let(:billing_period) { build(:billing_period, subscription: subscription) }
  let(:invoice) do
    build(:invoice, billing_period: billing_period, customer: subscription.customer)
  end

  def trigger(type, event)
    described_class.trigger(type, event, invoice)
  end

  def get_customer(invoice)
    invoice.billing_period.subscription.customer
  end

  describe '#after_create' do
    let(:segment_info) do
      { user_id: get_customer(invoice).organization.id,
        event: 'invoice created',
        properties: {
          invoice_date: invoice.issue_date,
          invoice_total: invoice.subtotal,
          details: invoice.details,
          customer_email: get_customer(invoice).email,
          customer_name: get_customer(invoice).name,
          organization_name: get_customer(invoice).organization.name,
          billing_information: get_customer(invoice).billing_information.serializable_hash
        } }
    end

    context 'when subscription is set to send invoice' do
      let(:auto_collection) { true }

      before do
        allow(Analytics).to receive(:track).with(segment_info)
      end

      it 'send Segment event with correct data' do
        trigger :after, :create
        expect(Analytics).to have_received(:track).with(segment_info)
      end
    end

    context 'when subscription is not set to send invoice' do
      let(:auto_collection) { false }

      before do
        allow(Analytics).to receive(:track)
      end

      it 'does not send Segment event' do
        trigger :after, :create
        expect(Analytics).not_to have_received(:track)
      end
    end
  end
end
