FactoryBot.define do
  factory :api_key do
    name { 'plutto_key' }
    bearer { create(:organization) }
    token { "api_key_#{SecureRandom.hex(32)}" }
  end
end
