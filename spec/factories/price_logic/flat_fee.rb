FactoryBot.define do
  factory :price_logic_flat_fee, class: 'PriceLogic::FlatFee' do
    plan_version
    price_cents { 1000 }
    price_currency { 'USD' }
  end
end
