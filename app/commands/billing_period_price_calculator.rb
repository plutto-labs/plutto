class BillingPeriodPriceCalculator < PowerTypes::Command.new(
  :billing_period
)

  def perform
    total_price = 0
    plan_subscription.plan_version_price_logics.each do |price_logic|
      billing_period_meter_data = billing_period_meter_data_for_price_logic(price_logic)
      total_price += price_logic.calculate_price(billing_period_meter_data&.count || 0)
    end
    total_price * period_duration_ratio
  end

  private

  def billing_period_meter_data_for_price_logic(price_logic)
    return nil unless price_logic.class.metered?

    meter_count = customer.meter_counts.find_by(meter: price_logic.meter)
    @billing_period.billing_period_meter_datas.find_by(meter_count: meter_count)
  end

  def customer
    @customer = plan_subscription.customer
  end

  def plan_subscription
    @plan_subscription = @billing_period.plan_subscription
  end

  def period_duration_ratio
    total_period_days = (@billing_period.from - @billing_period.to).to_i
    days_in_period = (@billing_period.from - @billing_period.billing_date).to_i
    ratio = days_in_period.to_f / total_period_days

    ratio > 1 ? 1 : ratio
  end
end
