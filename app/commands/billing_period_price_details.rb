class BillingPeriodPriceDetails < PowerTypes::Command.new(:billing_period)
  def perform
    total_price = 0
    details = []

    subscription.price_logics.each do |price_logic|
      billing_period_meter_data = billing_period_meter_data_for_price_logic(price_logic)
      price_logic_price = price_logic.calculate_price(
        billing_period_meter_data&.count(price_logic.meter_count_method) || 0
      )
      details.push(details_from_price_logic(price_logic, billing_period_meter_data,
                                            price_logic_price))

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
    @customer = subscription.customer
  end

  def subscription
    @subscription = @billing_period.subscription
  end

  def details_from_price_logic(price_logic, billing_period_meter_data, total_price)
    details = {}

    details[:type] = price_logic.class.const_get('NAME')
    details[:total_price] = total_price.amount.to_f
    details[:description] = details[:type]
    details[:id] = price_logic.id

    if price_logic.metered?
      details[:meter] = price_logic.meter.name
      details[:id] = price_logic.meter.id
      details[:quantity] = billing_period_meter_data&.count(price_logic.meter_count_method) || 0
      details[:description] = "#{details[:quantity]} x #{details[:meter]}"
    end

    details
  end
end
