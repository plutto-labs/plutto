class PasswordsController < Devise::PasswordsController
  prepend_before_action :require_no_authentication
  before_action :validate_email, only: [:create]

  # POST /user/password
  def create
    can_reset = ResetUserPassword.for(email: user_params[:email])
    if can_reset
      redirect_to widget_path
    else
      redirect_to(
        new_user_password_path,
        alert: 'Something happened, please contact us to contact@getplutto.com'
      )
    end
  end

  # GET /user/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]
  end

  # PUT /user/password
  def update
    user = User.reset_password_by_token(reset_user_password_params)

    if user.errors.empty?
      user.unlock_access! if unlockable?(user)
      sign_out user if user_signed_in?
      redirect_to widget_path, notice: 'Password changed'
    else
      set_minimum_password_length
      redirect_to widget_path, alert: 'Password failed to change'
    end
  end

  private

  def validate_email
    @user = User.find_by(email: user_params[:email])

    if @user.nil?
      redirect_to new_user_password_path, alert: 'Mail is not valid'
    end

    !@user.nil?
  end

  def reset_user_password_params
    user_params.except(:email)
  end

  def user_params
    params.require(:user).permit(
      :email,
      :reset_password_token,
      :password,
      :password_confirmation
    )
  end
end
