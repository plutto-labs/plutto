class Api::V1::PermissionGroupPermissionSerializer < Api::BaseSerializer
  attributes  :limit, :name

  def name
    object.permission.name
  end
end
