FactoryBot.define do
  factory :meter_event do
    meter
    customer
    meter_count
    amount { 105.5 }
    action { 'increment' }
    timestamp { DateTime.current }
    sequence(:identifier) { |i| "event_#{i}" }
  end
end
