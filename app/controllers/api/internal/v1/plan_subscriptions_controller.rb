class Api::Internal::V1::PlanSubscriptionsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def create
    plan_subscription = nil
    ActiveRecord::Base.transaction do
      plan_subscription = PlanSubscriptionCreator.for(plan_version: plan_version, customer: customer)
    end
    respond_with(plan_subscription)
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
