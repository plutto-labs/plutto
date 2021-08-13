FactoryBot.define do
  factory :per_unit, class: 'PriceLogic::PerUnit' do
    price_cents { 100 }
    price_currency { 'USD' }
  end
end
