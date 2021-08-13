FactoryBot.define do
  factory :tiered, class: 'PriceLogic::Tiered' do
    trait(:with_tiers) do
      after(:create) do |tier|
        create(:tier, tierable: tier, lower_limit: 0, upper_limit: 10, price_cents: 0,
                      price_currency: 'USD')
        create(:tier, tierable: tier, lower_limit: 11, upper_limit: 20, price_cents: 0,
                      price_currency: 'USD')
      end
    end
  end
end
