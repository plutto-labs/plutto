class PlanSubscriptionObserver < PowerTypes::Observer
  after_create :create_first_billing_period

  def create_first_billing_period
    StartNewBillingPeriod.for(plan_subscription: object, billing_period: nil)
  end
end
