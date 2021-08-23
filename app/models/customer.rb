class Customer < ApplicationRecord
  include IdentifierAttribute

  has_many :meter_events, dependent: :nullify
  has_many :plan_subscriptions, dependent: :destroy
  has_one :active_plan_subscription, -> { where(active: true) },
          class_name: 'PlanSubscription', inverse_of: :customer
  belongs_to :organization

  validates :identifier, uniqueness: true

  before_create :generate_identifier

  def add_plan_subcription(plan_version_id)
    plan_version = PlanVersion.find_by(id: plan_version_id)
    PlanSubscriptionCreator.for(plan_version: plan_version, customer: self)
  end

  private

  def generate_identifier
    init_identifier('customer')
  end
end

# == Schema Information
#
# Table name: customers
#
#  id              :bigint(8)        not null, primary key
#  email           :string           not null
#  name            :string
#  customer_info   :jsonb
#  identifier      :string           not null
#  organization_id :bigint(8)        not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_customers_on_identifier       (identifier) UNIQUE
#  index_customers_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
