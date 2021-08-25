require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
  factory :plan do
    organization
    name { 'Fixed' }
    sequence(:identifier) { |i| "plan_#{i}" }
  end
end
