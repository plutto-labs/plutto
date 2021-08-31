class Api::V1::MeterEventSerializer < Api::BaseSerializer
  attributes :timestamp, :amount, :action, :identifier, :created_at, :idempotency_key, :meter_id,
             :customer_id

  def customer_id
    object.customer.identifier
  end
end
