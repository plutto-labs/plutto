FactoryBot.define do
  factory :invoice do
    billing_period
    customer
    subtotal { usd(10) }
    tax { usd(0) }
    discount { usd(0) }
    issue_date { Date.current }
    aasm_state { 'new' }
    payed_at { Date.current }
    payment_method { 'bank_transfer' }
    tax_type { 'IVA' }
    sequence(:document_id) { |i| "doc_#{i}" }
  end
end
