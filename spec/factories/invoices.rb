FactoryBot.define do
  factory :invoice do
    billing_period
    sequence(:identifier) { |i| "invoice_#{i}" }
    subtotal { usd(10) }
    tax { usd(0) }
    discount { usd(0) }
    issue_date { Date.current }
  end
end
