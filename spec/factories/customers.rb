FactoryBot.define do
  factory :customer do
    organization
    email { Faker::Internet.email }
    name { Faker::Name.name }
    sequence(:identifier) { |i| "custom_#{i}" }

    after(:build) do |customer|
      customer.billing_information ||= build(:billing_information, customer: customer)
    end

    trait :active do
      after(:create) do |customer|
        customer.subscriptions << create(:subscription, active: true, customer: customer)
      end
    end

    trait :trial do
      after(:create) do |customer|
        create(
          :subscription, active: true, trial_finishes_at: Date.current + 1.day, customer: customer
        )
      end
    end

    trait :canceled do
      after(:create) do |customer|
        customer.subscriptions << create(:subscription, active: false, customer: customer)
      end
    end
  end
end
