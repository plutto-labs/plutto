class EndBillingPeriodJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0

  def perform(billing_period)
    EndBillingPeriod.for(billing_period: billing_period)
  end
end
