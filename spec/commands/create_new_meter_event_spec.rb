require 'rails_helper'

describe CreateNewMeterEvent do
  let(:amount) { 10 }
  let(:action) { 'set' }
  let(:meter_identifier) { 'meter' }
  let(:customer_identifier) { 'customer' }
  let(:idempotency_key) { nil }

  def perform
    described_class.for(
      timestamp: DateTime.current,
      amount: amount,
      action: action,
      meter_identifier: meter_identifier,
      customer_identifier: customer_identifier,
      idempotency_key: idempotency_key
    )
  end

  describe '#perform' do
    before do
      meter = create(
        :meter, :without_generate_identifier_callback, identifier: meter_identifier
      )
      customer = create(
        :customer, :without_generate_identifier_callback, identifier: customer_identifier
      )
      plan_subscription = create(:plan_subscription, customer: customer)
      meter_count = create(:meter_count, customer: customer, meter: meter)
      create(:billing_period, plan_subscription: plan_subscription)
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
