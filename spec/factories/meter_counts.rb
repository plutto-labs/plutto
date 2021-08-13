FactoryBot.define do
  factory :meter_count do
    billing_period
    meter
    count { 0 }
    sequence(:identifier) { |i| "count_#{i}" }
  end
end
