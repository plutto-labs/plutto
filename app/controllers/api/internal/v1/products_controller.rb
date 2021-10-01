class Api::Internal::V1::ProductsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(products))
  end

  def show
    authorize product
    respond_with(product, show: true)
  end

  def create
    product = authorize(
      Product.new(product_params.merge(organization_id: current_user.organization_id))
    )
    ActiveRecord::Base.transaction do
      product.add_pricing(**pricing_params)
      product.save!
    end
    respond_with(product)
  end

  def update
    authorize product
    product.update!(product_params)
    respond_with(product)
  end

  def destroy
    authorize product
    respond_with(product.destroy!)
  end

  private

  def product_params
    params.require(:product).permit(
      :name, :meter_id
    )
  end

  def pricing_params
    params.require(:pricing).permit(
      :currency, :name,
      price_logics_attributes: [
        :price,
        :type,
        :meter_count_method,
        { tiers_attributes: [:index, :upper_limit, :price] }
      ]
    )
  end

  def product
    @product ||= Product.find(params[:id])
  end

  def products
    @products ||= policy_scope(Product)
  end
end
