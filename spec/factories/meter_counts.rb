FactoryBot.define do
  factory :meter_count do
    customer
    meter
    count { 0 }
  end
end
