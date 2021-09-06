class Api::V1::PlanSubscriptionsController < Api::V1::BaseController
  def create
    respond_with(CreatePlanSubscription.for(plan_version: plan_version, customer: customer))
  end

  def update
    respond_with(plan_subscription.tap { |c| c.update!(update_params) })
  end

  private

  def plan_subscription
    @plan_subscription ||= policy_scope(PlanSubscription).find(params[:id])
  end

  def plan_version
    PlanVersion.find(create_params[:plan_version_id])
  end

  def customer
    policy_scope(Customer).find_by!(
      'id = ? OR identifier = ?', create_params[:customer_id], create_params[:customer_id]
    )
  end

  def create_params
    params.require(:plan_subscription).permit(:plan_version_id, :customer_id)
  end

  def update_params
    params.require(:plan_subscription).permit(:active)
  end
end
