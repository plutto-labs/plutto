require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
  factory :billing_period do
    plan_subscription
    from { Date.current }
    to { Date.current + 1.month }
    sequence(:identifier) { |i| "period_#{i}" }
  end
end
