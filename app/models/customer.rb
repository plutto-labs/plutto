class Customer < ApplicationRecord
  has_many :meter_counts, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :payment_methods, dependent: :destroy
  has_one :active_subscription, -> { where(active: true) },
          class_name: 'Subscription', inverse_of: :customer
  has_one :billing_information, dependent: :destroy, required: true
  belongs_to :organization

  accepts_nested_attributes_for :billing_information, allow_destroy: true

  validates :email, format: { with: Devise.email_regexp, message: "invalid email" }

  delegate :country_iso_code, to: :billing_information, allow_nil: true

  before_save :validate_uniqueness_of_identifier_within_organization

  scope :active, -> do
    includes(:active_subscription).where.not(
      active_subscription: { id: nil }
    ).where(active_subscription: { trial_finishes_at: nil })
  end

  scope :trial, -> do
    includes(:active_subscription).where.not(
      active_subscription: { trial_finishes_at: nil }
    )
  end

  def add_subscription(pricings)
    CreateSubscription.for(pricings: pricings, customer: self)
  end

  def current_billing_period
    active_subscription&.current_billing_period
  end

  def previous_billing_period
    active_subscription&.billing_periods&.second_to_last ||
      subscriptions.second_to_last&.billing_periods&.last
  end

  def current_period_details
    if current_billing_period
      BillingPeriodPriceDetails.for(billing_period: current_billing_period)
    end
  end

  def has_permission?(permission_name)
    permission = organization.permissions.find_by!(name: permission_name)
    plan_permission = active_subscription&.plan&.plan_permissions&.find_by(
      permission_id: permission.id
    )
    return false if plan_permission.nil?

    permission.metered? ? remaining_usage?(plan_permission) : !plan_permission.nil?
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

  def remaining_usage?(plan_permission)
    return true if plan_permission.limit.nil?

    meter_count = meter_counts.find_by(meter_id: plan_permission.permission.meter.id)
    current_usage = active_subscription.current_billing_period.billing_period_meter_datas.find_by(
      meter_count_id: meter_count.id
    ).count(plan_permission.permission.meter_count_method)

    current_usage < plan_permission.limit
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
