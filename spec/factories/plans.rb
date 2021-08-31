require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
  factory :plan do
    organization
    name { 'Fixed' }
    bills_at { 'end' }
    sequence(:identifier) { |i| "plan_#{i}" }
    billing_period_duration { 1.month }
  end
end
