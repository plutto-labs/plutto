class Api::V1::PermissionGroupSerializer < Api::BaseSerializer
  attributes  :id, :name, :permissions

  def permissions
    object.permission_group_permissions.map do |pgp|
      Api::V1::PermissionGroupPermissionSerializer.new(pgp)
    end
  end
end
