class SetDataToBillingPeriod < PowerTypes::Command.new(:billing_period, :count_type)
  def perform
    @billing_period.price_logics.each do |price_logic|
      if price_logic.metered?
        meter_count = find_or_create_meter_count(price_logic.meter)
        billing_period_meter_data = find_or_create_billing_period_meter_data(meter_count)
        set_count_to_billing_period_meter_data(billing_period_meter_data, meter_count, @count_type)
      end
    end
  end

  private

  def customer
    @customer ||= @billing_period.subscription.customer
  end

  def find_or_create_meter_count(meter)
    MeterCount.find_or_create_by!(customer: customer, meter: meter)
  end

  def find_or_create_billing_period_meter_data(meter_count)
    BillingPeriodMeterData.find_or_create_by!(
      billing_period: @billing_period,
      meter_count: meter_count
    )
  end

  def set_count_to_billing_period_meter_data(billing_period_meter_data, meter_count, count_type)
    return if !['initial_count', 'final_count'].include? count_type

    billing_period_meter_data.update(count_type.to_sym => meter_count.count)
  end
end
