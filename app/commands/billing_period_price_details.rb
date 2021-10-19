class BillingPeriodPriceDetails < PowerTypes::Command.new(:billing_period)
  def perform
    total_price = 0
    details = []

    details, total_price = price_logic_details(details, total_price)

    if permission_group
      details.push(details_for_permission_group(permission_group))
      total_price += permission_group.price
    end

    { price: total_price.zero? ? 0 : total_price.amount, details: details }.with_indifferent_access
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

  def permission_group
    @permission_group ||= @subscription.permission_group
  end

  def price_logic_details(details, total_price)
    subscription.price_logics.each do |price_logic|
      billing_period_meter_data = billing_period_meter_data_for_price_logic(price_logic)
      price_logic_price = price_logic.calculate_price(
        billing_period_meter_data&.count(price_logic.meter_count_method) || 0
      )
      details.push(price_logic_detail(price_logic, billing_period_meter_data, price_logic_price))
      total_price += price_logic_price
    end

    [details, total_price]
  end

  def price_logic_detail(price_logic, billing_period_meter_data, total_price)
    if price_logic.metered?
      return details_for_metered_price_logic(price_logic, billing_period_meter_data, total_price)
    end

    details_for_not_metered_price_logic(price_logic, total_price)
  end

  def details_for_metered_price_logic(price_logic, billing_period_meter_data, total_price)
    quantity = billing_period_meter_data&.count(price_logic.meter_count_method) || 0
    meter = price_logic.meter.name
    {
      type: price_logic.class.const_get('NAME'),
      meter: meter,
      total_price: total_price.amount.to_f,
      quantity: quantity,
      description: "#{quantity} x #{meter}",
      id: price_logic.meter.id
    }
  end

  def details_for_not_metered_price_logic(price_logic, total_price)
    {
      type: price_logic.class.const_get('NAME'),
      total_price: total_price.amount.to_f,
      description: price_logic.pricing.name,
      id: price_logic.id
    }
  end

  def details_for_permission_group(permission_group)
    {
      type: 'Permission Group',
      total_price: permission_group.price.amount.to_f,
      description: "Permission Group #{permission_group.name}",
      id: permission_group.id
    }
  end
end
