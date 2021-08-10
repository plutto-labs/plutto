FactoryBot.define do
  sequence(:email) { |i| "user-#{i}@email.com" }
  sequence(:name) { |i| "user #{i}" }
end
