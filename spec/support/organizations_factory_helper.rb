module OrganizationsFactoryHelper
  FactoryBot.define do
    trait(:without_default_permission_group) do
      before(:create) do |object|
        object.class.skip_callback(:create, :after, :create_default_permission_group, raise: false)
      end

      after(:create) do |object|
        object.class.skip_callback(:create, :after, :create_default_permission_group, raise: false)
      end
    end
  end
end
