class CreateSubscription < PowerTypes::Command.new(
  :pricings, :customer, trial_finishes_at: nil
)
  def perform
    active_subscription = @customer.active_subscription
    check_if_pricing_is_active(active_subscription)

    ActiveRecord::Base.transaction do
      if active_subscription.present?
        EndBillingPeriod.for(
          billing_period: active_subscription.current_billing_period,
          start_next_period: false
        )
        active_subscription.update(active: false)
      end

      create_subscription!
    end
  end

  private

  def create_subscription!
    Subscription.create!(
      customer: @customer,
      pricings: @pricings,
      active: true,
      trial_finishes_at: @trial_finishes_at
    )
  end

  def check_if_pricing_is_active(active_subscription)
    if active_subscription&.has_pricing?(@pricings)
      active_subscription.errors.add(
        :pricings,
        'already subscribed to this customer'
      )
      raise(ActiveRecord::RecordInvalid, active_subscription)
    end
  end
end
