class Api::Internal::V1::PlanVersionsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def create
    plan_version = authorize(plan.add_plan_version(**plan_version_params))
    plan_version.save!
    respond_with(plan_version)
  end

  def update
    authorize plan_version
    plan_version.update!(**plan_version_params)
    respond_with(plan_version)
  end

  def destroy
    authorize plan_version
    respond_with(plan_version.destroy!)
  end

  private

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

  def plan_version
    @plan_version ||= plan.plan_versions.find(params[:id])
  end

  def plan
    @plan ||= Plan.find(params[:plan_id])
  end
end
