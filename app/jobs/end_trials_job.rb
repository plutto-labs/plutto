class EndTrialsJob < ApplicationJob
  queue_as :default

  def perform
    Subscription.where(trial_finishes_at: Date.current - 1.day).find_each do |subscription|
      EndTrialJob.perform_later(subscription)
    end
  end
end
