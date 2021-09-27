class Api::Internal::V1::PlansController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(plans))
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
      :country_iso_code,
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
        :meter_count_method,
        { tiers_attributes: [:index, :upper_limit, :price] }
      ]
    )
  end

  def plan
    @plan ||= Plan.find(params[:id])
  end

  def plans
    @plans ||= policy_scope(Plan).includes([:default_version, { plan_versions: :price_logics }])
  end
end
