class EndTrialJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0

  def perform(subscription)
    ActiveRecord::Base.transaction do
      StartNewBillingPeriod.for(subscription: subscription, billing_period: nil)
      subscription.update!(trial_finishes_at: nil)
    end
  end
end
