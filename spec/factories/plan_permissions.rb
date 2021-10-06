FactoryBot.define do
  factory :plan_permission do
    plan
    permission
    limit { 5 }
  end
end
