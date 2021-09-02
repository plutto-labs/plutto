FactoryBot.define do
  factory :price_logic_per_unit, class: 'PriceLogic::PerUnit' do
    plan_version
    price_cents { 100 }
    price_currency { 'USD' }
    meter
    meter_count_method { 'period_sum' }
  end
end
