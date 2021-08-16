class Api::Internal::V1::CustomerSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :customer_info, :identifier
end
