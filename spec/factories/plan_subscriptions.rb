FactoryBot.define do
  factory :plan_subscription do
    customer
    plan_version
    sequence(:identifier) { |i| "subscription_#{i}" }
  end
end
