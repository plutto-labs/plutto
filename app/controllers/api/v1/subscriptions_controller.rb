class Api::V1::SubscriptionsController < Api::V1::BaseController
  def create
    authorize(Subscription)
    respond_with(
      CreateSubscription.for(
        pricings: pricings,
        customer: customer,
        billing_period_duration: create_params[:billing_period_duration],
        trial_finishes_at: create_params[:trial_finishes_at],
        bills_at: create_params[:bills_at]
      )
    )
  end

  def end_subscription
    authorize(subscription)
    end_billing_period
    respond_with(subscription)
  end

  private

  def subscription
    @subscription ||= policy_scope(Subscription).find(params[:id])
  end

  def pricings
    return if pricings_params[:pricing_ids].blank?

    @pricings = []
    pricings_params[:pricing_ids].each do |pricing_id|
      pricing = policy_scope(Pricing).find(pricing_id)
      @pricings << pricing if pricing
    end

    @pricings
  end

  def customer
    policy_scope(Customer).find_by!(
      'id = ? OR identifier = ?', create_params[:customer_id], create_params[:customer_id]
    )
  end

  def create_params
    params.require(:subscription).permit(:customer_id, :trial_finishes_at,
                                         :billing_period_duration, :bills_at)
  end

  def pricings_params
    params.require(:subscription).permit(pricing_ids: [])
  end

  def end_billing_period
    ActiveRecord::Base.transaction do
      EndBillingPeriod.for(
        billing_period: subscription.current_billing_period,
        start_next_period: false
      )
      subscription.end_subscription!
    end
  end
end
