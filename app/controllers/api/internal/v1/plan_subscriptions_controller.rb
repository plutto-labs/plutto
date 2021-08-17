class Api::Internal::V1::PlanSubscriptionsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def create
    plan_subscription = authorize(
      PlanSubscription.create!(plan_version: plan_version, customer: customer)
    )
    respond_with(plan_subscription)
  end

  def destroy
    authorize plan_subscription
    respond_with(plan_subscription.destroy!)
  end

  private

  def plan_subscription
    @plan_subscription ||= PlanSubscription.find(params[:id])
  end

  def plan_version
    @plan_version ||= PlanVersion.find(params[:plan_version_id])
  end

  def customer
    @customer ||= Customer.find(params[:customer_id])
  end
end
