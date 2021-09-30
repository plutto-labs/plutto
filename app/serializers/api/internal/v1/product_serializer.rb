class Api::Internal::V1::ProductSerializer < Api::BaseSerializer
  attributes :id, :name

  has_many :pricings
  has_one :meter
end
