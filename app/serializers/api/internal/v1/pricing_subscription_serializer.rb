class Api::Internal::V1::PricingSubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :pricings
end
