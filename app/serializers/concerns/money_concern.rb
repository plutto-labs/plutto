module MoneyConcern
  extend ActiveSupport::Concern

  def price
    ActionController::Base.helpers.humanized_money(object.price)
  end
end
