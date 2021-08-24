FactoryBot.define do
  factory :organization do
    name { 'Plutto' }
    sequence(:identifier) { |i| "organization_#{i}" }
  end
end
