FactoryBot.define do
  factory :permission_group_permission do
    permission_group
    permission
    limit { 5 }
  end
end
