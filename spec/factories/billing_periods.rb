FactoryBot.define do
  factory :billing_period do
    subscription
    from { Date.current }
    to { Date.current + 1.month }
  end
end
