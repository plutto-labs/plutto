class PlanSubscriptionService < PowerTypes::Service.new(:plan_subscription)
  def end_billing_period(start_new_period = true)
    ActiveRecord::Base.with_advisory_lock("meter-events-#{@plan_subscription.identifier}-lock") do
      ActiveRecord::Base.transaction do
        billing_period.billing_date = Date.current
        billing_period.billing_amount = get_billing_amount_for_period
        billing_period.save!
      end

      initialize_next_billing_period if start_new_period
    end
  end

  def initialize_next_billing_period
    first_day = billing_period ? billing_period.to + 1.day : Date.current

    next_billing_period = BillingPeriod.create(
      from: first_day,
      to: first_day + @plan_subscription.billing_period_duration,
      plan_subscription: @plan_subscription
    )

    StartBillingPeriod.for(billing_period: next_billing_period)
    create_invoice(next_billing_period) if @plan_subscription.bills_at_start?
  end

  private

  def billing_period
    @billing_period ||= @plan_subscription.current_billing_period
  end

  def create_invoice(billing_period)
    CreateInvoice.for(billing_period: billing_period)
  end
end
