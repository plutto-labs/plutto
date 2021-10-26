class Api::Internal::V1::PricingSerializer < ActiveModel::Serializer
  attributes :id, :name, :currency, :subscribed_customers, :product_name, :product_id

  has_many :price_logics

  def product_name
    object.product.name
  end

  def product_id
    object.product.id
  end

  def subscribed_customers
    object.pricing_subscriptions.count
  end
end
