class Api::V1::PriceLogicSerializer < Api::BaseSerializer
  include MoneyConcern

  attributes :id, :type, :price, :price_currency, :meter_count_method

  has_many :tiers

  def tiers
    object.tiers if object.respond_to?(:tiers)
  end

  def type
    object.type.split('::')[1]
  end
end
