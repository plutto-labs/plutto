FactoryBot.define do
  factory :meter do
    organization
    name { 'Requests' }
    meter_type { 'period_sum' }
  end
end
