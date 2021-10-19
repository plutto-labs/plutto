class Api::Internal::V1::ProductSerializer < Api::BaseSerializer
  attributes :id, :name

  has_many :pricings
  has_one :meter

  def pricings
    object.pricings.includes(:price_logics)
  end
end
