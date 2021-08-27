module TiersFactoryHelper
  FactoryBot.define do
    trait(:with_tiers) do
      transient do
        tiers_params { [] }
      end

      before(:create) do |resource, evaluator|
        tiers = []
        evaluator.tiers_params.each do |tier|
          tier = build(
            :price_logic_tier, price: tier[:price], price_currency: 'USD', upper_limit: tier[:limit]
          )
          tiers << tier
        end

        resource.tiers << tiers
      end
    end

    trait(:without_set_currency) do
      before(:create) do |object|
        object.class.skip_callback(:validation, :before, :set_currency, raise: false)
      end
    end
  end
end
