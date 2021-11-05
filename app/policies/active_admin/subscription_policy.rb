class ActiveAdmin::SubscriptionPolicy < ActiveAdmin::AdminPolicy
  def end_billing_period?
    true
  end

  def end_subscription?
    true
  end
end
