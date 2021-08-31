class CreateNewMeterEvent < PowerTypes::Command.new(
  :timestamp,
  :amount,
  :action,
  :meter_identifier,
  :customer_identifier,
  :idempotency_key
)
  def perform
    return if exist_meter_event?(@idempotency_key)

    meter_count.meter_events.create!(
      timestamp: @timestamp || DateTime.current,
      amount: @amount,
      action: @action,
      meter: meter,
      idempotency_key: @idempotency_key,
      billing_period: billing_period
    )
  end

  private

  def meter
    @meter ||= Meter.find_by!(identifier: @meter_identifier)
  end

  def customer
    @customer ||= Customer.find_by!(identifier: @customer_identifier)
  end

  def meter_count
    @meter_count ||= customer.meter_counts.find_or_create_by(meter_id: meter.id)
  end

  def billing_period
    @billing_period ||= customer.active_plan_subscription&.current_billing_period
  end

  def exist_meter_event?(idempotency_key)
    !idempotency_key.nil? &&
      meter_count.meter_events.find_by(idempotency_key: @idempotency_key).present?
  end
end
