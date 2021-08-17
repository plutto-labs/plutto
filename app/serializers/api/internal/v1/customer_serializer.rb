class Api::Internal::V1::CustomerSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :customer_info, :identifier

  has_one :plan_subscription
end
