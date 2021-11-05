class EndBillingPeriod < PowerTypes::Command.new(:billing_period, start_next_period: true)
  def perform
    return if @billing_period.nil?

    ActiveRecord::Base.with_advisory_lock("meter-events-#{subscription.id}-lock") do
      ActiveRecord::Base.transaction do
        to = [@billing_period.to, Date.current].min
        @billing_period.update(billing_date: Date.current, to: to)
        SetDataToBillingPeriod.for(billing_period: @billing_period, count_type: 'final_count')

        create_invoice unless @subscription.bills_at_start?

        if @start_next_period
          StartNewBillingPeriod.for(
            subscription: subscription,
            billing_period: @billing_period
          )
        end
      end
    end
  end

  private

  def subscription
    @subscription ||= @billing_period.subscription
  end

  def create_invoice
    CreateInvoice.for(
      billing_period: @billing_period,
      customer: subscription.customer
    )
  end
end
