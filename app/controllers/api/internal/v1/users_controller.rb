class Api::Internal::V1::UsersController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User

  def show
    respond_with(current_user, token: true)
  end
end
