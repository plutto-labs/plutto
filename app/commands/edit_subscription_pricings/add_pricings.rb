class EditSubscriptionPricings::AddPricings < EditSubscriptionPricings::Base
  private

  def action
    ensure_no_products_repeated!
    ensure_product_not_suscribed!
    ensure_no_meterd_pricings_when_bills_at_start!

    pricings_to_subscribe.each do |pricing|
      @subscription.pricing_subscriptions.build(
        subscription: @subscription,
        pricing: pricing
      )
    end
  end

  def ensure_no_products_repeated!
    product_ids = @pricings.map(&:product_id)
    repeated_products = product_ids - product_ids.uniq

    if product_ids.uniq.size != product_ids.size
      raise_unprocessable_entity(
        "Just one pricing per product allowed #{repeated_products[0]}"
      )
    end
  end

  def ensure_product_not_suscribed!
    pricings_products_id = @pricings.map(&:product_id).uniq
    repeated_products_id = pricings_products_id & @subscription.pricings.map(&:product_id)

    if repeated_products_id.size.positive?
      raise_unprocessable_entity(
        "Subscription already suscribed to #{repeated_products_id[0]}"
      )
    end
  end

  def pricings_to_subscribe
    pricings = @pricings - @subscription.pricings
    pricings = pricings.uniq
    pricings.uniq(&:product_id)
  end

  def ensure_no_meterd_pricings_when_bills_at_start!
    return unless @subscription.bills_at === 'start'

    @pricings.each do |pricing|
      pricing.price_logics.each do |logic|
        if logic.metered?
          raise_unprocessable_entity(
            "Metered pricing #{pricing.name} is not allowed when period bills at start"
          )
        end
      end
    end
  end
end
