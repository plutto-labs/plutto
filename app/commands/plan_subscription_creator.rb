class PlanSubscriptionCreator < PowerTypes::Command.new(:plan_version, :customer)
  def perform
    plan_subscription = nil

    ActiveRecord::Base.transaction do
      @customer.active_plan_subscription&.update(active: false)
      plan_subscription = PlanSubscription.create(
        customer: @customer, plan_version: @plan_version, active: true
      )
    end

    plan_subscription
  end
end
