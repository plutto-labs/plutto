class Api::Internal::V1::PricingSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :price_logics
end