class AnalyticsService < PowerTypes::Service.new(:organization)
  def mrr_arr_per_month(currency = 'USD')
    mrr = organization_invoices_by_month(currency)
    arr = mrr[:total].transform_values { |v| v * 12 }.to_h
    { mrr: mrr.except(:total), arr: arr }
  end

  def active_subscriptions_accumulated_per_month(currency = 'USD')
    organization_subscriptions_count_by_month(currency)
  end

  def customers_created_per_month
    group_by_date(customers).count
  end

  def numbers
    {
      churn_rate: churn_rate.round(4) * 100
    }
  end

  private

  def group_by_date(records, column = :created_at, format = '%b')
    records.unscope(:order).group_by_month(column, last: 12, format: format)
  end

  def organization_subscriptions_count_by_month(currency)
    subscriptions = subscriptions(currency)
    group_by_date(BillingPeriod.where(subscription: subscriptions), :from).count
  end

  def organization_invoices_by_month(currency)
    invoices = invoices(currency)
    {
      paid: invoices_amount_per_month(invoices.paid),
      not_paid: invoices_amount_per_month(invoices.not_paid),
      created: invoices_amount_per_month(invoices.where(status: 'created')),
      voided: invoices_amount_per_month(invoices.voided),
      posted: invoices_amount_per_month(invoices.posted),
      total: invoices_amount_per_month(invoices)
    }
  end

  def invoices_amount_per_month(collection)
    group_by_date(collection).sum('net_cents')
  end

  def churn_rate
    churned_subscriptions_in_period / total_subscriptions_at_period_start.to_f
  end

  def churned_subscriptions_in_period
    subscriptions_last_period = BillingPeriod.where(subscription: subscriptions,
                                                    to: last_period)
                                             .includes(:subscription).pluck(:subscription_id).uniq
    subscriptions_this_period = BillingPeriod.where(subscription: subscriptions_last_period,
                                                    from: last_period)
                                             .includes(:subscription).pluck(:subscription_id).uniq

    subscriptions_last_period.count - subscriptions_this_period.count
  end

  def total_subscriptions_at_period_start
    total = BillingPeriod.where(subscription: subscriptions, to: last_period).count
    total.zero? ? 1 : total
  end

  def invoices(currency)
    @invoices ||= @organization.invoices.where(currency: currency)
  end

  def subscriptions(currency = nil)
    @subscriptions ||= if currency
                         @organization.subscriptions.where(currency: currency)
                       else
                         @organization.subscriptions
                       end
  end

  def customers
    @customers ||= @organization.customers
  end

  def beginning_of_previous_month
    @beginning_of_previous_month ||= beginning_of_month - 1.month
  end

  def beginning_of_month
    @beginning_of_month ||= Date.current.beginning_of_month
  end

  def last_period
    @last_period ||= beginning_of_previous_month..beginning_of_previous_month.end_of_month
  end
end
