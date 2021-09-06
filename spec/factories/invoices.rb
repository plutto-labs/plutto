FactoryBot.define do
  factory :invoice do
    billing_period
    customer
    subtotal { usd(10) }
    tax { usd(0) }
    discount { usd(0) }
    issue_date { Date.current }
    aasm_state { 'new' }
  end
end
