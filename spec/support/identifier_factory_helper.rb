module IdentifierFactoryHelper
  FactoryBot.define do
    trait :without_generate_identifier_callback do
      after(:build) do |object|
        object.class.skip_callback(:create, :before, :generate_identifier, raise: false)
      end
    end
  end
end
