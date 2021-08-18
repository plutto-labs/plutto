class PlanSubscription < ApplicationRecord
  include IdentifierAttribute

  has_many :billing_periods, dependent: :nullify
  belongs_to :plan_version
  belongs_to :customer

  validates :identifier, uniqueness: true

  before_create :generate_identifier

  private

  def generate_identifier
    init_identifier('subscription')
  end
end

# == Schema Information
#
# Table name: plan_subscriptions
#
#  id              :bigint(8)        not null, primary key
#  customer_id     :bigint(8)        not null
#  plan_version_id :bigint(8)        not null
#  identifier      :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  active          :boolean          default(FALSE)
#
# Indexes
#
#  index_plan_subscriptions_on_customer_id      (customer_id)
#  index_plan_subscriptions_on_identifier       (identifier) UNIQUE
#  index_plan_subscriptions_on_plan_version_id  (plan_version_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (plan_version_id => plan_versions.id)
#
