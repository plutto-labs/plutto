class Api::V1::PermissionGroupsController < Api::V1::BaseController
  def index
    authorize(PermissionGroup)
    respond_with(policy_scope(PermissionGroup))
  end
end
