require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
  factory :meter_event do
    meter
    meter_count
    billing_period
    amount { 105.5 }
    action { 'increment' }
    timestamp { DateTime.current }
    sequence(:identifier) { |i| "event_#{i}" }
    idempotency_key { 'unique_key' }
  end
end
