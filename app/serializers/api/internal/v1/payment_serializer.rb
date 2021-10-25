class Api::Internal::V1::PaymentSerializer < ActiveModel::Serializer
  attributes :id, :gateway, :id_in_gateway, :created_at

  has_one :payment_method
  has_one :invoice
end
