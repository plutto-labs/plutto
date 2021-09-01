class PlanSubscriptionService < PowerTypes::Service.new(:plan_subscription)
  def end_billing_period(start_new_period = true)
    ActiveRecord::Base.transaction do
      billing_period.billing_date = DateTime.current
      create_invoice(billing_period) unless @plan_subscription.bills_at_start?
      billing_period.save!
    end

    initialize_next_billing_period if start_new_period
  end

  def initialize_next_billing_period
    first_day = billing_period ? billing_period.billing_date + 1.day : DateTime.current

    next_billing_period = BillingPeriod.create(from: first_day,
                                               to: first_day + 1.month,
                                               plan_subscription: @plan_subscription)

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
