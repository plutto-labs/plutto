FactoryBot.define do
  factory :meter_event do
    meter
    meter_count
    billing_period
    amount { 105.5 }
    action { 'increment' }
    timestamp { DateTime.current }
    idempotency_key { 'unique_key' }
  end
end
