require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
  factory :meter_count do
    customer
    meter
    count { 0 }
    sequence(:identifier) { |i| "count_#{i}" }
  end
end
