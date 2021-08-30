require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
  factory :billing_period_meter_data do
    initial_count { '10' }
    final_count { '15' }
    billing_period
    meter_count
  end
end
