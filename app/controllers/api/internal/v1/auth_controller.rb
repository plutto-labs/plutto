class Api::Internal::V1::AuthController < Api::Internal::V1::BaseController
  def create
    user = User.where('LOWER(email) = ?', auth_params[:email].downcase).last
    if user&.valid_password?(auth_params[:password])
      user.identify_user
      return respond_with(user, token: true)
    end

    respond_with({ errors: { 'login': ['Credenciales incorrectas'] } }, status: :unauthorized)
  end

  def destroy
    sign_out current_user
    respond_with({}, status: :ok)
  end

  def sign_up
    ActiveRecord::Base.transaction do
      organization = Organization.create!(name: params[:auth][:organization_name])
      user = User.new(user_params)
      user.organization = organization

      if user.save!
        user.identify_user
        return respond_with(user, token: true)
      end
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end

  def user_params
    params.require(:auth).permit(:email, :password, :password_confirmation)
  end

  def identify_user(user)
    Analytics.identify(
      user_id: user.id,
      traits: { email: user.email, created_at: user.created_at }
    )
    Analytics.group(
      user_id: user.id,
      group_id: user.organization.id,
      traits: { organization_name: user.organization.name }
    )
  end
end
