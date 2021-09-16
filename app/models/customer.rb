class Customer < ApplicationRecord
  has_many :meter_counts, dependent: :destroy
  has_many :plan_subscriptions, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_one :active_plan_subscription, -> { where(active: true) },
          class_name: 'PlanSubscription', inverse_of: :customer
  has_one :billing_information, dependent: :destroy, required: true
  belongs_to :organization

  accepts_nested_attributes_for :billing_information, allow_destroy: true

  delegate :id, to: :organization, prefix: true, allow_nil: true

  validates :email, format: { with: Devise.email_regexp, message: "invalid email" }

  before_save :validate_uniqueness_of_identifier_within_organization

  def add_plan_subcription(plan_version_id)
    plan_version = PlanVersion.find_by(id: plan_version_id)
    CreatePlanSubscription.for(plan_version: plan_version, customer: self)
  end

  private

  def generate_id
    init_id('customer')
    self.identifier = id unless identifier
  end

  def validate_uniqueness_of_identifier_within_organization
    customer = organization.customers.find_by(identifier: identifier)
    if customer && customer != self
      errors.add(:identifier, :taken)
      raise ActiveRecord::RecordInvalid, self
    end
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
#  identifier      :string
#
# Indexes
#
#  index_customers_on_organization_id                 (organization_id)
#  index_customers_on_organization_id_and_identifier  (organization_id,identifier) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
