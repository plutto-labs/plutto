class Api::V1::PricingSerializer < Api::BaseSerializer
  attributes :id, :name, :currency, :product_id

  has_many :price_logics
end
