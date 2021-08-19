class Api::Internal::V1::PriceLogicSerializer < ActiveModel::Serializer
  attributes :id, :type, :price_cents, :price_currency

  has_many :tiers

  def tiers
    object.tiers if object.respond_to?(:tiers)
  end
end
