class Api::BaseController < PowerApi::BaseController
  include Api::ErrorConcern

  skip_before_action :verify_authenticity_token

  respond_to :json
end
