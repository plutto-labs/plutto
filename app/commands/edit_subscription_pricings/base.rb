class EditSubscriptionPricings::Base < PowerTypes::Command.new(:pricings, :subscription)
  def perform
    return if @pricings.blank?

    check_if_subscription_is_active!
    ensure_correct_pricing_currencies!

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

  def ensure_correct_pricing_currencies!
    if @pricings.pluck(:currency).uniq - [@subscription.currency] != []
      raise_unprocessable_entity('Pricing currencies must be the same')
    end
  end

  def raise_unprocessable_entity(detail)
    raise(ApiException::Errors::UnprocessableEntity.new(detail: detail))
  end
end
