require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
  factory :customer do
    email
    name
    organization
    sequence(:identifier) { |i| "customer_#{i}" }
  end
end
