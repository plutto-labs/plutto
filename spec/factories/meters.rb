require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
  factory :meter do
    organization
    name { 'Requests' }
    sequence(:identifier) { |i| "meter_#{i}" }
    meter_type { 'period_sum' }
  end
end
