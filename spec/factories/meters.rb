FactoryBot.define do
  factory :meter do
    organization
    name { 'Requests' }
    sequence(:identifier) { |i| "meter_#{i}" }
  end
end
