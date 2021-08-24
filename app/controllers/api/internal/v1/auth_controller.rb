class Api::Internal::V1::AuthController < Api::Internal::V1::BaseController
  def create
    user = User.where('LOWER(email) = ?', auth_params[:email].downcase).last
    if user&.valid_password?(auth_params[:password])
      identify_user(user)
      return respond_with(user, token: true)
    end

    respond_with({ errors: { 'login': ['Credenciales incorrectas'] } }, status: :unauthorized)
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end

  def identify_user(user)
    Analytics.identify(user_id: user.id, traits: { email: user.email })
    Analytics.group(
      user_id: user.id,
      group_id: user.organization.id,
      traits: { organization_name: user.organization.name }
    )
  end
end
