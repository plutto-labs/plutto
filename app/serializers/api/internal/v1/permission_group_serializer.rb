class Api::Internal::V1::PermissionGroupSerializer < ActiveModel::Serializer
  include MoneyConcern

  attributes :id, :name, :price, :permissions, :currency

  def permissions
    object.permission_group_permissions.map do |pgp|
      permission = pgp.permission
      {
        id: permission.id,
        name: permission.name,
        limit: pgp.limit,
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
