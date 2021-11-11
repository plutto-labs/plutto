FactoryBot.define do
  factory :api_key do
    name { 'plutto_key' }
    bearer { create(:organization) }
    category { 'sk' }
  end
end
