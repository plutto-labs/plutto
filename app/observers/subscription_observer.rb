class SubscriptionObserver < PowerTypes::Observer
  after_create :create_first_billing_period

  def create_first_billing_period
    unless object.in_trial?
      StartNewBillingPeriod.for(subscription: object, billing_period: nil)
    end
  end
end
