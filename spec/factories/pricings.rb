FactoryBot.define do
  factory :pricing do
    product
    name { 'USD basic' }
    currency { 'USD' }
  end
end
