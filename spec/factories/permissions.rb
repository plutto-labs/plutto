FactoryBot.define do
  factory :permission do
    organization
    sequence(:name) { |i| "permission_#{i}" }
    meter { create(:meter) }
    meter_count_method { 'period_sum' }
  end
end
