class Api::Internal::V1::InvoicesController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(current_user.organization.invoices))
  end
end
