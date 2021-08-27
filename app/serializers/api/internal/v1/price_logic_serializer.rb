class Api::Internal::V1::PriceLogicSerializer < ActiveModel::Serializer
  include MoneyConcern

  attributes :id, :type, :price, :price_currency, :meter_id

  has_many :tiers

  def tiers
    object.tiers if object.respond_to?(:tiers)
  end
end
