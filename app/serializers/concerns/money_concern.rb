module MoneyConcern
  extend ActiveSupport::Concern

  def price
    object.price&.amount
  end

  def subtotal
    object.subtotal&.amount
  end

  def tax
    object.tax&.amount
  end

  def discount
    object.discount&.amount
  end

  def total
    object.total&.amount
  end
end
