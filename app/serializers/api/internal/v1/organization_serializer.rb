class Api::Internal::V1::OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :settings
end
