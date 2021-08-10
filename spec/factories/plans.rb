FactoryBot.define do
  factory :plan do
    organization
    name { 'Fixed' }
    sequence(:identifier) { |i| "plan_#{i}" }
  end
end
