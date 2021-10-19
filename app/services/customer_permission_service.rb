class CustomerPermissionService < PowerTypes::Service.new(
  :permission,
  :plan_permission,
  :customer
)
  def plan_permission_limit
    return nil if @plan_permission.nil?

    @plan_permission.limit
  end

  def usage_for_current_period
    return nil if @plan_permission.nil?

    meter_count = @customer.meter_counts.find_by(meter_id: @plan_permission.permission.meter_id)
    @customer.active_subscription.current_billing_period.billing_period_meter_datas.find_by(
      meter_count_id: meter_count.id
    ).count(@permission.meter_count_method)
  end

  def customer_allowed?
    return false if @plan_permission.nil?
    return true if plan_permission_limit.nil?

    @permission.metered? ? usage_for_current_period < plan_permission_limit : true
  end
end
