class Api::Internal::V1::SubscriptionsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def create
    respond_with(
      CreateSubscription.for(
        pricings: pricings,
        customer: customer,
        billing_period_duration: params['billing_period_duration'],
        trial_finishes_at: params['trial_finishes_at'],
        bills_at: params['bills_at']
      )
    )
  end

  def edit_trial
    if edit_trial_params[:start_subscription]
      ActiveRecord::Base.transaction do
        StartNewBillingPeriod.for(subscription: subscription, billing_period: nil)
        subscription.update!(trial_finishes_at: nil)
      end
    elsif edit_trial_params[:trial_finishes_at]
      subscription.update!(trial_finishes_at: edit_trial_params[:trial_finishes_at])
    end

    respond_with(subscription)
  end

  def add_pricings
    EditSubscriptionPricings::AddPricings.for(
      subscription: subscription,
      pricings: pricings([:product, :price_logics])
    )
    respond_with(subscription)
  end

  def remove_pricings
    EditSubscriptionPricings::RemovePricings.for(
      subscription: subscription,
      pricings: pricings
    )
    respond_with(subscription)
  end

  private

  def pricings(includes = [])
    return if pricings_params[:pricing_ids].blank?

    policy_scope(Pricing).includes(includes).where(id: pricings_params[:pricing_ids]).uniq
  end

  def customer
    policy_scope(Customer).find_by!(
      'id = ? OR identifier = ?', params[:customer_id], params[:customer_id]
    )
  end

  def subscription
    @subscription ||= policy_scope(Subscription).find(params[:subscription_id])
  end

  def edit_trial_params
    params.permit(:trial_finishes_at, :start_subscription, :bills_at)
  end

  def pricings_params
    params.permit(pricing_ids: [])
  end
end
