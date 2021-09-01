class SetInitialDataToBillingPeriod < PowerTypes::Command.new(:billing_period)
  def perform
    @billing_period.plan_version_price_logics.each do |price_logic|
      if price_logic.class.metered?
        meter_count = find_or_create_meter_count(price_logic.meter)
        billing_period_meter_data = find_or_create_billing_period_meter_data(meter_count)
        billing_period_meter_data.update(initial_count: meter_count.count)
      end
    end
  end

  private

  def customer
    @customer ||= @billing_period.plan_subscription.customer
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
end
