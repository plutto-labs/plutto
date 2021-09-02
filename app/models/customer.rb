class Customer < ApplicationRecord
  has_many :meter_counts, dependent: :nullify
  has_many :plan_subscriptions, dependent: :destroy
  has_one :active_plan_subscription, -> { where(active: true) },
          class_name: 'PlanSubscription', inverse_of: :customer
  belongs_to :organization

  delegate :id, to: :organization, prefix: true

  def add_plan_subcription(plan_version_id)
    plan_version = PlanVersion.find_by(id: plan_version_id)
    CreatePlanSubscription.for(plan_version: plan_version, customer: self)
  end
end

# == Schema Information
#
# Table name: customers
#
#  id              :string           not null, primary key
#  email           :string           not null
#  name            :string
#  organization_id :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_customers_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
