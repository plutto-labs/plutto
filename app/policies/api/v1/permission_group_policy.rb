class Api::V1::PermissionGroupPolicy < Api::V1::ApiPolicy
  def index?
    true
  end

  class Scope < Scope
    def resolve
      scope.where(organization_id: organization.id).includes([:permission_group_permissions])
    end
  end
end
