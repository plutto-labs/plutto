class EndTrialsJob < ApplicationJob
  queue_as :default

  def perform
    PlanSubscription.where(trial_date: Date.current - 1.day).find_each do |plan_subscription|
      EndTrialJob.perform_later(plan_subscription)
    end
  end
end
