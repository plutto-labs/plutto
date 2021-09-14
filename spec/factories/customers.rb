FactoryBot.define do
  factory :customer do
    organization
    email { Faker::Internet.email }
    name { Faker::Name.name }
    sequence(:identifier) { |i| "custom_#{i}" }

    after(:build) do |customer|
      customer.billing_information ||= build(:billing_information, customer: customer)
    end
  end
end
