FactoryBot.define do
  factory :admin_user do
    sequence(:email) { |i| "admin_#{i}@plutto.cl" }
    password { 'password' }
  end
end
