class EditSubscriptionPricings::RemovePricings < EditSubscriptionPricings::Base
  private

  def action
    @pricings.each do |pricing|
      if @subscription.pricings.includes(:price_logics).include?(pricing)
        pricing.pricing_subscriptions.find_by(subscription: @subscription).destroy
      end
    end
  end
end
