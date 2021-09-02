FactoryBot.define do
  factory :billing_period do
    plan_subscription
    from { Date.current }
    to { Date.current + 1.month }
  end
end
