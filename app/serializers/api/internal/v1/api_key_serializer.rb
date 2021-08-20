class Api::Internal::V1::ApiKeySerializer < ActiveModel::Serializer
  attributes :id, :created_at, :token, :name
end
