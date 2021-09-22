class Api::Internal::V1::PlanSubscriptionsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def create
    respond_with(
      CreatePlanSubscription.for(
        plan_version: plan_version,
        customer: customer,
        trial_finishes_at: params['trial_finishes_at']
      )
    )
  end

  private

  def plan_version
    @plan_version ||=
      (params[:plan_version_id] && policy_scope(PlanVersion).find(params[:plan_version_id])) ||
      plan&.default_version
  end

  def plan
    @plan ||= params[:plan_id] && policy_scope(Plan).find(params[:plan_id])
  end

  def customer
    policy_scope(Customer).find_by!(
      'id = ? OR identifier = ?', params[:customer_id], params[:customer_id]
    )
  end
end
