class CreateNewMeterEvent < PowerTypes::Command.new(
  :timestamp,
  :amount,
  :action,
  :meter_id,
  :customer_id,
  :idempotency_key,
  :organization
)
  def perform
    return if exist_meter_event?(@idempotency_key)

    ActiveRecord::Base.with_advisory_lock("meter-events-#{lock_id}-lock") do
      meter_count.meter_events.create!(
        timestamp: @timestamp || DateTime.current,
        amount: @amount,
        action: @action,
        meter: meter,
        idempotency_key: @idempotency_key,
        billing_period: billing_period
      )
    end
  end

  private

  def meter
    @meter ||= @organization.meters.find(@meter_id)
  end

  def customer
    @customer ||= @organization.customers.find_by!(
      'id = ? OR identifier = ?', @customer_id, @customer_id
    )
  end

  def meter_count
    @meter_count ||= customer.meter_counts.find_or_create_by(meter_id: meter.id)
  end

  def subscription
    @subscription ||= customer.active_subscription
  end

  def billing_period
    @billing_period ||= subscription&.current_billing_period
  end

  def exist_meter_event?(idempotency_key)
    !idempotency_key.nil? &&
      meter_count.meter_events.find_by(idempotency_key: @idempotency_key).present?
  end

  def lock_id
    subscription&.id || customer.id
  end
end
