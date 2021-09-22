class CreatePlanSubscription < PowerTypes::Command.new(
  :plan_version, :customer,
  trial_finishes_at: nil
)
  def perform
    active_plan_subscription = @customer.active_plan_subscription
    check_if_plan_version_is_active(active_plan_subscription)

    ActiveRecord::Base.transaction do
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
    PlanSubscription.create!(
      customer: @customer,
      plan_version: @plan_version,
      active: true,
      trial_finishes_at: @trial_finishes_at
    )
  end

  def check_if_plan_version_is_active(active_plan_subscription)
    if active_plan_subscription&.plan_version_id == @plan_version.id
      active_plan_subscription.errors.add(
        :plan_version,
        'Customer already subscribed to this plan version'
      )
      raise(ActiveRecord::RecordInvalid, active_plan_subscription)
    end
  end
end
