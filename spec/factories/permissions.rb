FactoryBot.define do
  factory :permission do
    organization
    name { "MyString" }
    meter { create(:meter) }
    meter_count_method { 'period_sum' }
  end
end
