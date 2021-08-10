FactoryBot.define do
  factory :customer do
    email
    name
    organization
    sequence(:identifier) { |i| "customer_#{i}" }
  end
end
