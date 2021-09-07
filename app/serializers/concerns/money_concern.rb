module MoneyConcern
  extend ActiveSupport::Concern

  def price
    object.price.amount
  end

  def subtotal
    object.subtotal.amount
  end
end
