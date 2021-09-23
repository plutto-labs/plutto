FactoryBot.define do
  factory :payment_method do
    customer
    gateway { 0 }
    category { 0 }
    gateway_info { "" }
    currency { 0 }
    last_4_digits { '1234' }
    card_brand { 0 }
  end
end
