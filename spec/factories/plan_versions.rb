FactoryBot.define do
  factory :plan_version do
    plan
    previous_version { nil }
    deployed { false }
    version { 1 }
  end
end
