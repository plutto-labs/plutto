class Api::V1::PermissionGroupPermissionSerializer < Api::BaseSerializer
  attributes  :limit, :name

  def limit
    object_limit = object.limit
    return object_limit unless object_limit.nil?

    object.permission.metered? ? 'Infinity' : object_limit
  end

  def name
    object.permission.name
  end
end
