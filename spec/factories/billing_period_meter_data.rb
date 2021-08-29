FactoryBot.define do
  factory :billing_period_meter_data do
    initial_count { '10' }
    final_count { '15' }
    billing_period
    meter_count
  end
end
