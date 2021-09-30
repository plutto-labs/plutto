class Api::V1::PricingSerializer < Api::BaseSerializer
  attributes :id, :name, :currency

  has_many :price_logics
end
