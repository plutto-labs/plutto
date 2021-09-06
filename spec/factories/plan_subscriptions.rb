FactoryBot.define do
  factory :plan_subscription do
    customer
    plan_version
    auto_collection { true }
    price_type { 'tax_inclusive' }
  end
end
