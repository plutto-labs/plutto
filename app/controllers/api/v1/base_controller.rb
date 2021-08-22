class Api::V1::BaseController < Api::BaseController
  include Api::ApiKeyAuthenticatable

  before_action do
    self.namespace_for_serializer = ::Api::V1
  end

  respond_to :json
end
