FactoryBot.define do
  factory :plan_version do
    plan
    previous_version { nil }
    deployed { false }
    name { 'V1' }
    sequence(:identifier) { |i| "version_#{i}" }
  end
end
