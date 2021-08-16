module TiersFactoryHelper
  FactoryBot.define do
    trait(:with_tiers) do
      after(:create) do |resource|
        create(:price_logic_tier, tierable: resource, lower_limit: 0, upper_limit: 10,
                                  price_cents: 0, price_currency: 'USD')
        create(:price_logic_tier, tierable: resource, lower_limit: 11, upper_limit: 20,
                                  price_cents: 100, price_currency: 'USD')
      end
    end
  end
end
