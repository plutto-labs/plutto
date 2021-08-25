require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
  factory :plan_subscription do
    customer
    plan_version
    sequence(:identifier) { |i| "subscription_#{i}" }
  end
end
