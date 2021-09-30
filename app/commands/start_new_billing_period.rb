class StartNewBillingPeriod < PowerTypes::Command.new(:subscription, :billing_period)
  def perform
    first_day = @billing_period ? @billing_period.to + 1.day : Date.current

    new_billing_period = BillingPeriod.create(
      from: first_day,
      to: first_day + @subscription.billing_period_duration - 1.day,
      subscription: @subscription
    )

    SetDataToBillingPeriod.for(billing_period: new_billing_period, count_type: 'initial_count')
    create_invoice(new_billing_period) if @subscription.bills_at_start?
  end

  private

  def create_invoice(billing_period)
    CreateInvoice.for(
      billing_period: billing_period,
      customer: @subscription.customer
    )
  end
end
