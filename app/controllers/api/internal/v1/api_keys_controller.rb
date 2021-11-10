class Api::Internal::V1::ApiKeysController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(ApiKey.where(index_params)))
  end

  def create
    api_key = authorize(ApiKey.create!(create_params))
    respond_with(api_key)
  end

  def destroy
    authorize api_key
    respond_with(api_key.destroy!)
  end

  private

  def index_params
    params.permit(:bearer_type, :bearer_id)
  end

  def create_params
    params.require(:api_key).permit(:bearer_type, :bearer_id, :name, :category)
  end

  def api_key
    @api_key ||= ApiKey.find(params[:id])
  end
end
