class Api::Internal::V1::ProductSerializer < Api::BaseSerializer
  attributes :id, :name

  has_many :pricings, if: :show?
end
