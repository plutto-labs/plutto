class EndBillingPeriodsJob < ApplicationJob
  queue_as :default

  def perform
    BillingPeriod.where(to: Date.current - 1.day, billing_date: nil).find_each do |billing_period|
      EndBillingPeriodJob.perform_later(billing_period)
    end
  end
end
