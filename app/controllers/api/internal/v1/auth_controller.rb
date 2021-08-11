class Api::Internal::V1::AuthController < Api::Internal::V1::BaseController
  def create
    user = User.where('LOWER(email) = ?', auth_params[:email].downcase).last
    return respond_with(user, token: true) if user&.valid_password?(auth_params[:password])

    respond_with({ errors: { 'login': ['Credenciales incorrectas'] } }, status: :unauthorized)
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
