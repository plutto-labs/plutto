FactoryBot.define do
  factory :price_logic_flat_fee, class: 'PriceLogic::FlatFee' do
    pricing
    price_cents { 1000 }
    price_currency { 'USD' }
    meter_count_method { 'period_sum' }
  end
end
