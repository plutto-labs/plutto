class Api::Internal::V1::PlansController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(plans))
  end

  def show
    authorize plan
    respond_with(plan, show: true)
  end

  def create
    plan = authorize(
      Plan.create!(plan_params.merge(organization_id: current_user.organization_id))
    )
    respond_with(plan)
  end

  private

  def plan_params
    params.require(:plan).permit(
      :name, :price_currency, :price,
      plan_permissions_attributes: [:id, :limit]
    )
  end

  def plan
    @plan ||= Plan.find(params[:id])
  end

  def plans
    @plans ||= policy_scope(Plan).includes([:meter, :pricings])
  end
end
