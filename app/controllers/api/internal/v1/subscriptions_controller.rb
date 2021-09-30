class Api::Internal::V1::SubscriptionsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def create
    respond_with(
      CreateSubscription.for(
        pricings: pricings,
        customer: customer,
        trial_finishes_at: params['trial_finishes_at']
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

  private

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
      'id = ? OR identifier = ?', params[:customer_id], params[:customer_id]
    )
  end

  def subscription
    @subscription ||= policy_scope(Subscription).find(params[:subscription_id])
  end

  def edit_trial_params
    params.permit(:trial_finishes_at, :start_subscription)
  end

  def pricings_params
    params.permit(pricing_ids: [])
  end
end
