class BillingPeriodPriceCalculator < PowerTypes::Command.new(
  :meter_counts, :plan_subscription, :total_period_days, :days_in_periods
)

  def perform
    total_price = 0
    @plan_subscription.plan_version_price_logics.each do |price_logic|
      meter_count = meter_count_for_price_logic(price_logic)
      total_price += price_logic.calculate_price(meter_count&.count)
    end

    total_price * period_duration_ratio
  end

  private

  def meter_count_for_price_logic(price_logic)
    return nil unless price_logic.class.metered?

    @meter_counts.find { |meter_count| meter_count.meter_id == price_logic.meter_id }
  end

  def period_duration_ratio
    @days_in_periods.to_f / @total_period_days
  end
end
