class Api::Internal::V1::PermissionsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(permissions))
  end

  def create
    permission = authorize(
      Permission.create!(permission_params.merge(organization_id: current_user.organization_id))
    )
    respond_with(permission)
  end

  def destroy
    authorize permission
    respond_with(permission.destroy!)
  end

  private

  def permission_params
    params.require(:permission).permit(
      :name, :meter_id, :meter_count_method
    )
  end

  def permissions
    @permissions ||= policy_scope(Permission)
  end

  def permission
    @permission ||= Permission.find(params[:id])
  end
end
