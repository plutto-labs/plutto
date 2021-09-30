class Api::V1::TierSerializer < Api::BaseSerializer
  include MoneyConcern

  attributes :index, :upper_limit, :lower_limit, :price, :price_currency
end
