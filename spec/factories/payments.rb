FactoryBot.define do
  factory :payment do
    payment_method
    invoice
    id_in_gateway { "12313421432515" }
    gateway { 1 }
  end
end
