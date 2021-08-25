require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
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
