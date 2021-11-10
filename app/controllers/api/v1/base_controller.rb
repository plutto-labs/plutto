class Api::V1::BaseController < Api::BaseController
  include Api::ApiKeyAuthenticatable
  include Pundit

  prepend_before_action :authenticate_with_api_key!

  before_action do
    self.namespace_for_serializer = ::Api::V1
  end

  after_action do
    Analytics.track(
      user_id: organization.id,
      event: "external API request"
    )
    Analytics.track(
      user_id: organization.id,
      event: "external #{action_name} #{controller_name}"
    )
  end

  private

  def organization
    @organization ||= @current_bearer if @current_bearer.is_a? Organization
  end

  def pundit_user
    @current_api_key
  end

  def policy_scope(scope)
    super([:api, :v1, scope])
  end

  def authorize(record, query = nil)
    super([:api, :v1, record], query)
  end
end
