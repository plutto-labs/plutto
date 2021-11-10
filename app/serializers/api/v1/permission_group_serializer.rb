class Api::V1::PermissionGroupSerializer < Api::BaseSerializer
  include MoneyConcern

  attributes :id, :name, :price, :permissions, :currency

  def permissions
    object.permission_group_permissions.map do |pgp|
      Api::V1::PermissionGroupPermissionSerializer.new(pgp)
    end
  end

  def currency
    object.price_currency
  end
end
