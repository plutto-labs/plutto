class Api::V1::ProductSerializer < Api::BaseSerializer
  attributes  :id, :name

  has_one :meter
  has_many :pricings
end
