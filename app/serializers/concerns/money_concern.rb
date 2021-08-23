module MoneyConcern
  extend ActiveSupport::Concern

  def price
    object.price.amount
  end
end
