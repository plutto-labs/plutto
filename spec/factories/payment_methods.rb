FactoryBot.define do
  factory :payment_method do
    customer
    gateway { 0 }
    category { 0 }
    gateway_info { "" }
  end
end
