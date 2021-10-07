FactoryBot.define do
  factory :plan do
    organization
    name { "MyString" }
    price_currency { 0 }
  end
end
