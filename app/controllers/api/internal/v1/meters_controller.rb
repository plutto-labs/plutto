class Api::Internal::V1::MetersController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(meters))
  end

  def show
    authorize meter
    respond_with(meter)
  end

  def create
    meter = authorize(
      Meter.create!(meter_params.merge(organization_id: current_user.organization_id))
    )
    respond_with(meter)
  end

  def update
    authorize meter
    meter.update!(meter_params)
    respond_with(meter)
  end

  def destroy
    authorize meter
    respond_with(meter.destroy!)
  end

  private

  def meter_params
    params.require(:meter).permit(:name)
  end

  def meter
    @meter ||= policy_scope(Meter).find(params[:id])
  end

  def meters
    @meters ||= policy_scope(Meter).reverse_order
  end
end
