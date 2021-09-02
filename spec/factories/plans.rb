FactoryBot.define do
  factory :plan do
    organization
    name { 'Fixed' }
    bills_at { 'end' }
    billing_period_duration { 1.month }
  end
end
