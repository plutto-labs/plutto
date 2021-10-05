class Api::V1::SubscriptionsController < Api::V1::BaseController
  def create
    authorize(Subscription)
    respond_with(
      CreateSubscription.for(
        pricings: pricings(pricings_params, [:product, :price_logics]),
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

  def add_pricings
    EditSubscriptionPricings::AddPricings.for(
      subscription: subscription,
      pricings: pricings(edit_pricings_params, [:product, :price_logics])
    )
    respond_with(subscription)
  end

  def remove_pricings
    EditSubscriptionPricings::RemovePricings.for(
      subscription: subscription,
      pricings: pricings(edit_pricings_params)
    )
    respond_with(subscription)
  end

  private

  def subscription
    @subscription ||= policy_scope(Subscription).find(params[:subscription_id])
  end

  def pricings(params, includes = [])
    return if params[:pricing_ids].blank?

    policy_scope(Pricing).includes(includes).where(id: params[:pricing_ids]).uniq
  end

  def customer
    policy_scope(Customer).find_by!(
      'id = CAST(? AS VARCHAR) OR identifier = CAST(? AS VARCHAR)',
      create_params[:customer_id], create_params[:customer_id]
    )
  end

  def create_params
    params.require(:subscription).permit(:customer_id, :trial_finishes_at,
                                         :billing_period_duration, :bills_at)
  end

  def pricings_params
    params.require(:subscription).permit(pricing_ids: [])
  end

  def edit_pricings_params
    params.permit(pricing_ids: [])
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
