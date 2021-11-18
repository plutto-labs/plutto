class ResetUserPassword < PowerTypes::Command.new(:email)
  include Devise::Controllers::UrlHelpers

  def perform
    return false if user.nil?

    token, enc_token = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token = enc_token
    @user.reset_password_sent_at = Time.now.utc

    if @user.save(validate: false)
      send_reset_password_email(token)

      true
    end
  end

  private

  def user
    @user = User.find_by(email: @email)
  end

  def send_reset_password_email(token)
    Analytics.track(
      user_id: user.id,
      event: 'password recovery',
      properties: {
        email: user.email,
        url: edit_password_url(user, reset_password_token: token)
      }
    )
  end

  def main_app
    Rails.application.routes.url_helpers
  end
end
