class Api::V1::PermissionGroupSerializer < Api::BaseSerializer
  attributes  :id, :name

  has_many :permission_group_permissions, serializer: Api::V1::PermissionGroupPermissionSerializer
end
