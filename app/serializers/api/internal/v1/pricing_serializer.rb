class Api::Internal::V1::PricingSerializer < ActiveModel::Serializer
  attributes :id, :name, :currency, :product_name

  has_many :price_logics

  def product_name
    object.product.name
  end
end
