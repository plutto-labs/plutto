class Api::V1::CustomerPermissionSerializer < Api::BaseSerializer
  attributes :current_usage, :limit, :allowed, :name
end
