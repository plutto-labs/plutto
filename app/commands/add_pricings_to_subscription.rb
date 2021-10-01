class AddPricingsToSubscription < PowerTypes::Command.new(:pricings, :subscription)
  def perform
    return if @pricings.blank?

    check_if_subscription_is_active!
    ensure_no_products_repeated!
    ensure_same_pricing_currencies!

    ActiveRecord::Base.transaction do
      add_pricings_to_subscription
      @subscription.save!
    end
  end

  private

  def add_pricings_to_subscription
    @pricings.each do |pricing|
      @subscription.pricing_subscriptions.build(
        subscription: @subscription,
        pricing: pricing
      )
    end
  end

  def check_if_subscription_is_active!
    unless @subscription.active?
      @subscription.errors.add(
        :pricings,
        'susbcription is inactive'
      )
      raise(ActiveRecord::RecordInvalid, @subscription)
    end
  end

  def ensure_no_products_repeated!
    products = @pricings.map(&:product)
    repeated_products = products.select { |product| products.count(product) > 1 }
    raise_unprocessable_entity('Products repeated') if repeated_products.any?

    repeated_products = products & @subscription.products
    if repeated_products.any?
      raise_unprocessable_entity(
        "Subscription already suscribed to #{repeated_products[0].id}"
      )
    end
  end

  def ensure_same_pricing_currencies!
    currencies = @pricings.map(&:currency)
    raise_unprocessable_entity('Pricing currencies must be the same') if currencies.uniq.size > 1
  end

  def raise_unprocessable_entity(detail)
    raise(ApiException::Errors::UnprocessableEntity.new(detail: detail))
  end
end
