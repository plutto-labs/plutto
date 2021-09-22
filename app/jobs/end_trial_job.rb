class EndTrialJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0

  def perform(plan_subscription)
    ActiveRecord::Base.transaction do
      StartNewBillingPeriod.for(plan_subscription: plan_subscription, billing_period: nil)
      plan_subscription.update!(trial_finishes_at: nil)
    end
  end
end
