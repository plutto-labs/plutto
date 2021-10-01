class CreateSubscription < PowerTypes::Command.new(
  :pricings, :customer, :billing_period_duration, bills_at: 'end', trial_finishes_at: nil
)
  def perform
    ensure_at_leat_one_pricing!
    active_subscription = @customer.active_subscription
    check_if_pricing_is_active(active_subscription)

    ActiveRecord::Base.transaction do
      if active_subscription.present?
        end_billing_period(active_subscription)
      end

      subscription = create_subscription!
      EditSubscriptionPricings::AddPricings.for(subscription: subscription, pricings: @pricings)
      subscription.save!
      subscription.reload
    end
  end

  private

  def create_subscription!
    Subscription.create!(
      customer: @customer,
      active: true,
      billing_period_duration: @billing_period_duration,
      trial_finishes_at: @trial_finishes_at,
      bills_at: @bills_at,
      currency: @pricings.first.currency
    )
  end

  def end_billing_period(subscription)
    EndBillingPeriod.for(
      billing_period: subscription.current_billing_period,
      start_next_period: false
    )
    subscription.update(active: false)
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

  def ensure_at_leat_one_pricing!
    if @pricings.empty?
      raise(ApiException::Errors::UnprocessableEntity.new(detail:
        "Can't create subscription with no valid pricings"))
    end
  end
end
