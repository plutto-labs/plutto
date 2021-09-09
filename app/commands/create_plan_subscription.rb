class CreatePlanSubscription < PowerTypes::Command.new(:plan_version, :customer)
  def perform
    unless can_subscribe?
      raise ActiveModel::ForbiddenAttributesError, "Customer's organization does not match plan's"
    end

    ActiveRecord::Base.transaction do
      active_plan_subscription = @customer.active_plan_subscription
      if active_plan_subscription.present?
        EndBillingPeriod.for(
          billing_period: active_plan_subscription.current_billing_period,
          start_next_period: false
        )
        active_plan_subscription.update(active: false)
      end

      create_plan_subscription!
    end
  end

  private

  def create_plan_subscription!
    PlanSubscription.create!(customer: @customer, plan_version: @plan_version, active: true)
  end

  def can_subscribe?
    @plan_version.plan.organization_id == @customer.organization_id
  end
end
