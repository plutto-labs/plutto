class PlanSubscription < ApplicationRecord
  include PowerTypes::Observable

  has_many :billing_periods, dependent: :destroy
  belongs_to :plan_version
  belongs_to :customer

  delegate :price_logics, to: :plan_version, allow_nil: true, prefix: true
  delegate :bills_at_start?, to: :plan_version
  delegate :billing_period_duration, to: :plan_version

  validate :trial_finishes_at_is_valid_datetime

  enum price_type: { tax_inclusive: 0, tax_exclusive: 1 }, _suffix: true

  def current_billing_period
    billing_periods.order(created_at: :asc).last
  end

  def end_subscription!
    unless active
      errors.add(:active, 'Subscription already inactive')
      raise(ActiveRecord::RecordInvalid, self)
    end

    update!(active: false)
  end

  def in_trial?
    return false if trial_finishes_at.nil?

    trial_finishes_at >= Date.current
  end

  private

  def generate_id
    init_id('subscription')
  end

  def trial_finishes_at_is_valid_datetime
    if !attributes_before_type_cast['trial_finishes_at'].nil?
      DateTime.parse(attributes_before_type_cast['trial_finishes_at'].to_s)
    end
  rescue Date::Error
    errors.add(:trial_finishes_at, 'must be a valid date')
  end
end

# == Schema Information
#
# Table name: plan_subscriptions
#
#  id                :string           not null, primary key
#  customer_id       :string           not null
#  plan_version_id   :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  active            :boolean          default(FALSE)
#  auto_collection   :boolean          default(TRUE)
#  price_type        :integer          default("tax_inclusive")
#  trial_finishes_at :datetime
#
# Indexes
#
#  index_plan_subscriptions_on_customer_id      (customer_id)
#  index_plan_subscriptions_on_plan_version_id  (plan_version_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (plan_version_id => plan_versions.id)
#
