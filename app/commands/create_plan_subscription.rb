class CreatePlanSubscription < PowerTypes::Command.new(:plan_version, :customer)
  def perform
    active_plan_subscription = @customer.active_plan_subscription
    if active_plan_subscription.present?
      plan_subscription_service.end_billing_period(start_new_period: false)
      active_plan_subscription.update(active: false)
    end

    PlanSubscription.create(
      customer: @customer, plan_version: @plan_version, active: true
    )
  end

  private

  def plan_subscription_service
    @plan_subscription_service ||= PlanSubscriptionService.new(
      plan_subscription: @customer.active_plan_subscription
    )
  end
end
