class EndBillingPeriod < PowerTypes::Command.new(:billing_period, start_next_period: true)
  def perform
    return if @billing_period.nil?

    ActiveRecord::Base.with_advisory_lock("meter-events-#{plan_subscription.id}-lock") do
      ActiveRecord::Base.transaction do
        @billing_period.update(billing_date: Date.current)
        SetDataToBillingPeriod.for(billing_period: @billing_period, count_type: 'final_count')

        create_invoice unless @plan_subscription.bills_at_start?

        if @start_next_period
          StartNewBillingPeriod.for(
            plan_subscription: plan_subscription,
            billing_period: @billing_period
          )
        end
      end
    end
  end

  private

  def plan_subscription
    @plan_subscription ||= @billing_period.plan_subscription
  end

  def create_invoice
    CreateInvoice.for(
      billing_period: @billing_period,
      customer: plan_subscription.customer
    )
  end
end
