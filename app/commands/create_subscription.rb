class CreateSubscription < PowerTypes::Command.new(
  :pricings,
  :customer,
  :billing_period_duration,
  bills_at: 'end',
  trial_finishes_at: nil,
  permission_group_id: nil
)
  def perform
    ensure_pricings_or_permission_group!
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
      permission_group_id: @permission_group_id
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

  def ensure_pricings_or_permission_group!
    if @pricings.blank? && !@permission_group_id
      raise(ApiException::Errors::UnprocessableEntity.new(detail:
        "Can't create subscription with no valid pricings or permission group"))
    end
  end

  def currency
    permission_group&.price_currency || @pricings.first.currency
  end

  def permission_group
    @permission_group ||= if @permission_group_id.nil?
                            nil
                          else
                            PermissionGroup.find(@permission_group_id)
                          end
  end
end
