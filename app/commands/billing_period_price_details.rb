class BillingPeriodPriceDetails < PowerTypes::Command.new(:billing_period)
  def perform
    total_price = 0
    details = {}

    plan_subscription.plan_version_price_logics.each_with_index do |price_logic, i|
      billing_period_meter_data = billing_period_meter_data_for_price_logic(price_logic)
      price_logic_price = price_logic.calculate_price(
        billing_period_meter_data&.count(price_logic.meter_count_method) || 0
      )
      price_logic_price *= period_duration_ratio if !price_logic.metered?
      details[i] = details_from_price_logic(price_logic, billing_period_meter_data,
                                            price_logic_price)

      total_price += price_logic_price
    end

    { price: total_price, details: details }.with_indifferent_access
  end

  private

  def billing_period_meter_data_for_price_logic(price_logic)
    return nil unless price_logic.metered?

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
    return 1 if plan_subscription.bills_at_start?

    total_period_days = (
      @billing_period.to.to_datetime - @billing_period.from.to_datetime
    ).to_i
    days_in_period = (
      @billing_period.billing_date.to_datetime - @billing_period.from.to_datetime
    ).to_i + 1

    ratio = days_in_period.to_f / total_period_days

    ratio > 1 ? 1 : ratio
  end

  def details_from_price_logic(price_logic, billing_period_meter_data, total_price)
    details = {}

    details[:type] = price_logic.class.const_get('NAME')
    details[:total_price_cents] = total_price.cents

    if price_logic.metered?
      details[:meter] = price_logic.meter.name
      details[:quantity] = billing_period_meter_data.count(price_logic.meter_count_method) || 0
    end

    details
  end
end
