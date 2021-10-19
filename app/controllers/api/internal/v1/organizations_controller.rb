class Api::Internal::V1::OrganizationsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User

  def update
    organization.update!(organization_params)
    respond_with(organization)
  end

  private

  def organization
    @organization ||= current_user.organization
  end

  def organization_params
    params.require(:organization).permit(
      settings: {}
    )
  end
end
