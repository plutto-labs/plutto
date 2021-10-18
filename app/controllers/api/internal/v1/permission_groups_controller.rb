class Api::Internal::V1::PermissionGroupsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(permission_groups))
  end

  def show
    authorize permission_group
    respond_with(permission_group, show: true)
  end

  def create
    permission_group = authorize(
      PermissionGroup.create!(
        permission_group_params.merge(organization_id: current_user.organization_id)
      )
    )
    respond_with(permission_group)
  end

  private

  def permission_group_params
    params.require(:permission_group).permit(
      :name, :price_currency, :price,
      permission_group_permissions_attributes: [:permission_id, :limit]
    )
  end

  def permission_group
    @permission_group ||= PermissionGroup.find(params[:id])
  end

  def permission_groups
    @permission_groups ||= policy_scope(PermissionGroup).includes(
      permission_group_permissions: :permission
    )
  end
end
