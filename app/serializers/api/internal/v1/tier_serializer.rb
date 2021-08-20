class Api::Internal::V1::TierSerializer < ActiveModel::Serializer
  include MoneyConcern

  attributes :index, :upper_limit, :lower_limit, :price, :price_currency
end
