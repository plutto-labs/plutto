FactoryBot.define do
  factory :price_logic_tier, class: 'PriceLogic::Tier' do
    tierable { create(:price_logic_tiered) }
    sequence(:index) { |n| n }
    lower_limit { 0 }
    upper_limit { 100 }
    price_cents { 1000 }
    price_currency { 'USD' }
  end
end
