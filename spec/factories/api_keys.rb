FactoryBot.define do
  factory :api_key do
    name { 'plutto_key' }
    bearer { create(:organization) }
    token { "sk_live_#{SecureRandom.hex(32)}" }
  end
end
