class PlanSubscription < ApplicationRecord
  include PowerTypes::Observable

  has_many :billing_periods, dependent: :nullify
  belongs_to :plan_version
  belongs_to :customer

  delegate :price_logics, to: :plan_version, allow_nil: true, prefix: true
  delegate :bills_at_start?, to: :plan_version
  delegate :billing_period_duration, to: :plan_version

  def current_billing_period
    billing_periods.order(created_at: :asc).last
  end

  private

  def generate_id
    init_id('subscription')
  end
end

# == Schema Information
#
# Table name: plan_subscriptions
#
#  id              :string           not null, primary key
#  customer_id     :string           not null
#  plan_version_id :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  active          :boolean          default(FALSE)
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
