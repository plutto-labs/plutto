class Api::Internal::V1::PaymentMethodSerializer < ActiveModel::Serializer
  attributes :card_brand, :currency, :category, :last_4_digits
end
