class Api::V1::MeterEventSerializer < Api::BaseSerializer
  attributes :id, :timestamp, :amount, :action, :created_at, :idempotency_key, :meter_id,
             :customer_id

  def customer_id
    object.customer.id
  end
end
