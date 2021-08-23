class PlanSubscriptionCreator < PowerTypes::Command.new(:plan_version, :customer)
  def perform
    @customer.active_plan_subscription&.update(active: false)
    PlanSubscription.create(
      customer: @customer, plan_version: @plan_version, active: true
    )
  end
end
