class Api::Internal::V1::PricingsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def create
    pricing = authorize(product.add_pricing(**pricing_params))
    pricing.save!
    respond_with(pricing)
  end

  def update
    authorize pricing
    pricing.update!(**pricing_params)
    respond_with(pricing)
  end

  def destroy
    authorize pricing
    respond_with(pricing.destroy!)
  end

  private

  def pricing_params
    params.require(:pricing).permit(
      :currency, :name,
      price_logics_attributes: [
        :price,
        :type,
        :meter_count_method,
        { tiers_attributes: [:index, :lower_limit, :upper_limit, :price] }
      ]
    )
  end

  def pricing
    @pricing ||= product.pricings.find(params[:id])
  end

  def product
    @product ||= policy_scope(Product).find(params[:product_id])
  end
end
