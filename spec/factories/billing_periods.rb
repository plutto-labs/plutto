FactoryBot.define do
  factory :billing_period do
    plan_subscription
    from { DateTime.current }
    to { DateTime.current + 1.month }
    sequence(:identifier) { |i| "period_#{i}" }
  end
end
