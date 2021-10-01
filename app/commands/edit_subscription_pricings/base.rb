class EditSubscriptionPricings::Base < PowerTypes::Command.new(:pricings, :subscription)
  def perform
    return if @pricings.blank?

    check_if_subscription_is_active!
    ensure_same_pricing_currencies!

    ActiveRecord::Base.transaction do
      action
      @subscription.save!
    end
  end

  private

  def action
    raise NotImplementedError # :nocov:
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

  def ensure_same_pricing_currencies!
    currencies = @pricings.map(&:currency)
    raise_unprocessable_entity('Pricing currencies must be the same') if currencies.uniq.size > 1
  end

  def raise_unprocessable_entity(detail)
    raise(ApiException::Errors::UnprocessableEntity.new(detail: detail))
  end
end
