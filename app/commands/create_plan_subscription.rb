class CreatePlanSubscription < PowerTypes::Command.new(:plan_version, :customer)
  def perform
    new_plan_subscription = nil
    ActiveRecord::Base.transaction do
      active_plan_subscription = @customer.active_plan_subscription
      if active_plan_subscription.present?
        plan_subscription_service(active_plan_subscription)
          .end_billing_period(start_new_period: false)
        active_plan_subscription.update(active: false)
      end

      new_plan_subscription = create_plan_subscription!
      plan_subscription_service(new_plan_subscription).initialize_next_billing_period
    end

    new_plan_subscription
  end

  private

  def plan_subscription_service(plan_subscription)
    PlanSubscriptionService.new(plan_subscription: plan_subscription)
  end

  def create_plan_subscription!
    PlanSubscription.create!(customer: @customer, plan_version: @plan_version, active: true)
  end
end
