FactoryBot.define do
  factory :permission do
    name { "MyString" }
    meter
    meter_count_method { 1 }
  end
end
