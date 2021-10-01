FactoryBot.define do
  factory :subscription do
    customer
    auto_collection { true }
    price_type { 'tax_inclusive' }
    trial_finishes_at { nil }
    billing_period_duration { 1.month }
    bills_at { 'end' }
    currency { 'USD' }
  end
end
