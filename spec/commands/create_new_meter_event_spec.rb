require 'rails_helper'

describe CreateNewMeterEvent do
  let(:amount) { 10 }
  let(:organization) { create(:organization) }
  let(:meter) { create(:meter, organization: organization) }
  let(:customer) { create(:customer, organization: organization) }
  let(:idempotency_key) { nil }

  def perform
    described_class.for(
      timestamp: DateTime.current,
      amount: amount,
      action: 'set',
      meter_id: meter.id,
      customer_id: customer.id,
      idempotency_key: idempotency_key,
      organization: organization
    )
  end

  describe '#perform' do
    before do
      subscription = create(:subscription, customer: customer)
      meter_count = create(:meter_count, customer: customer, meter: meter)
      create(:billing_period, subscription: subscription)
      create(:meter_event, idempotency_key: idempotency_key, meter_count: meter_count)
    end

    context 'when idempotency key is not nil and exists' do
      let(:idempotency_key) { 'idempotency_key' }

      it { expect(perform).to eq(nil) }
    end

    context 'when idempotency key no exists' do
      it { expect { perform }.to change { MeterEvent.count }.by(1) }
    end
  end
end
