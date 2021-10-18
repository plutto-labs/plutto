FactoryBot.define do
  factory :plan_permission do
    permission_group
    permission
    limit { 5 }
  end
end
