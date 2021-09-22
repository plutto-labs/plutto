class Api::V1::PlanSubscriptionsController < Api::V1::BaseController
  def create
    authorize(PlanSubscription)
    respond_with(
      CreatePlanSubscription.for(
        plan_version: plan_version,
        customer: customer,
        trial_finishes_at: create_params[:trial_finishes_at]
      )
    )
  end

  def end_subscription
    authorize(plan_subscription)
    end_billing_period
    respond_with(plan_subscription)
  end

  private

  def plan_subscription
    @plan_subscription ||= policy_scope(PlanSubscription).find(params[:id])
  end

  def plan_version
    @plan_version ||= (create_params[:plan_version_id] &&
        policy_scope(PlanVersion).find(create_params[:plan_version_id])) || plan&.default_version
  end

  def plan
    @plan ||= create_params[:plan_id] && policy_scope(Plan).find(create_params[:plan_id])
  end

  def customer
    policy_scope(Customer).find_by!(
      'id = ? OR identifier = ?', create_params[:customer_id], create_params[:customer_id]
    )
  end

  def create_params
    params.require(:plan_subscription).permit(
      :plan_version_id, :plan_id, :customer_id, :trial_finishes_at
    )
  end

  def end_billing_period
    ActiveRecord::Base.transaction do
      EndBillingPeriod.for(
        billing_period: plan_subscription.current_billing_period,
        start_next_period: false
      )
      plan_subscription.end_subscription!
    end
  end
end
