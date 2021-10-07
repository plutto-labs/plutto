class CustomerPermission
  include ActiveModel::Model
  include ActiveModel::Serialization
  attr_reader :current_usage, :limit, :allowed, :name

  def initialize(permission, plan_permission, customer)
    @permission = permission
    @plan_permission = plan_permission
    @customer = customer

    @current_usage = customer_permission_service.usage_for_current_period
    @limit = customer_permission_service.plan_permission_limit
    @allowed = customer_permission_service.customer_allowed?
    @name = @permission.name
  end

  private

  def customer_permission_service
    @customer_permission_service ||= CustomerPermissionService.new(
      permission: @permission,
      plan_permission: @plan_permission,
      customer: @customer
    )
  end
end
