class Api::Internal::V1::PlanSerializer < ActiveModel::Serializer
  include MoneyConcern

  attributes :id, :name, :price, :permissions, :currency

  def permissions
    object.plan_permissions.map do |plan_permission|
      permission = plan_permission.permission
      {
        id: permission.id,
        name: permission.name,
        limit: plan_permission.limit,
        meter_id: permission.meter_id,
        meter_count_method: permission.meter_count_method,
        meter_name: permission.meter&.name
      }
    end
  end

  def currency
    object.price_currency
  end
end
