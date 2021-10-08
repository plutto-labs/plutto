class CreateSubscription < PowerTypes::Command.new(
  :pricings,
  :customer,
  :billing_period_duration,
  bills_at: 'end',
  trial_finishes_at: nil,
  plan_id: nil
)
  def perform
    ensure_pricings_or_plan!
    active_subscription = @customer.active_subscription
    check_if_pricing_is_active(active_subscription)

    ActiveRecord::Base.transaction do
      if active_subscription.present?
        end_billing_period(active_subscription)
      end

      subscription = instantiate_subscription
      EditSubscriptionPricings::AddPricings.for(subscription: subscription, pricings: @pricings)
      subscription.save!
      subscription.reload
    end
  end

  private

  def instantiate_subscription
    Subscription.new(
      customer: @customer,
      active: true,
      billing_period_duration: @billing_period_duration,
      trial_finishes_at: @trial_finishes_at,
      bills_at: @bills_at,
      currency: currency,
      plan_id: @plan_id
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

  def ensure_pricings_or_plan!
    if @pricings.blank? && !@plan_id
      raise(ApiException::Errors::UnprocessableEntity.new(detail:
        "Can't create subscription with no valid pricings or plan"))
    end
  end

  def currency
    plan&.price_currency || @pricings.first.currency
  end

  def plan
    @plan ||= @plan_id.nil? ? nil : Plan.find(@plan_id)
  end
end
