module Api::ApiKeyAuthenticatable
  extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_api_key, :current_bearer

  def authenticate_with_api_key!
    @current_bearer = authenticate_or_request_with_http_token &method(:authenticator)
  rescue ActiveRecord::RecordNotFound
    respond_with_unauthorized
  end

  private

  attr_writer :current_api_key, :current_bearer

  def authenticator(http_token, _options)
    @current_api_key = ApiKey.authenticate_by_token! http_token

    current_api_key&.bearer
  end
end
