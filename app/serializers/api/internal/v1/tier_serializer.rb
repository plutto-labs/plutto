class Api::Internal::V1::TierSerializer < ActiveModel::Serializer
  attributes :index, :upper_limit, :lower_limit, :price_cents
end
