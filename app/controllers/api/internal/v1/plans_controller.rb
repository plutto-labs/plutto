class Api::Internal::V1::PlansController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(Plan.where(organization_id: current_user.organization_id)))
  end

  def show
    authorize plan
    respond_with(plan, include_versions: true)
  end

  def create
    plan = authorize(
      Plan.new(plan_params.merge(organization_id: current_user.organization_id))
    )
    ActiveRecord::Base.transaction do
      plan.add_plan_version(**plan_version_params)
      plan.save!
    end
    respond_with(plan)
  end

  def update
    authorize plan
    plan.update!(plan_params)
    respond_with(plan)
  end

  def destroy
    authorize plan
    respond_with(plan.destroy!)
  end

  private

  def plan_params
    params.require(:plan).permit(
      :name,
      :currency,
      :bills_at,
      :billing_period_duration
    )
  end

  def plan_version_params
    params.require(:plan_version).permit(
      price_logics_attributes: [
        :price,
        :type,
        :meter_id,
        { tiers_attributes: [:index, :lower_limit, :upper_limit, :price] }
      ]
    )
  end

  def plan
    @plan ||= Plan.find(params[:id])
  end
end
