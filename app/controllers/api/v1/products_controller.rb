class Api::V1::ProductsController < Api::V1::BaseController
  def index
    authorize(Product)
    respond_with(policy_scope(Product).includes([:meter, { pricings: :price_logics }]))
  end
end
