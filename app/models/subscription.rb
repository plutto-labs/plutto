class Subscription < ApplicationRecord
  include PowerTypes::Observable

  has_many :billing_periods, dependent: :destroy
  has_many :pricing_subscriptions, dependent: :destroy
  has_many :pricings, through: :pricing_subscriptions
  has_many :price_logics, through: :pricings
  belongs_to :customer

  delegate :country_iso_code, to: :customer

  enum currency: Currencies.keys
  enum bills_at: { start: 0, end: 1 }, _prefix: :bills_at
  enum price_type: { tax_inclusive: 0, tax_exclusive: 1 }, _suffix: true

  attribute :billing_period_duration, :duration

  validate :trial_finishes_at_is_valid_datetime
  validate :no_metered_for_bills_at_start

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

  def tax_rate
    Countries.find_by(country_iso_code, 'tax_rate')
  end

  def has_pricing?(pricings)
    pricings.any? { |pricing| self.pricings.include?(pricing) }
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

  def no_metered_for_bills_at_start
    if bills_at_start? && price_logics.any?(&:metered?)
      errors.add(:bills_at, 'Cannot bill at start of period if there is use-based price logics')
    end
  end
end

# == Schema Information
#
# Table name: subscriptions
#
#  id                      :string           not null, primary key
#  customer_id             :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  active                  :boolean          default(FALSE)
#  auto_collection         :boolean          default(TRUE)
#  price_type              :integer          default("tax_inclusive")
#  trial_finishes_at       :datetime
#  bills_at                :integer          default("start")
#  billing_period_duration :string
#  currency                :integer          default("USD"), not null
#  country_iso_code        :integer          default(0), not null
#
# Indexes
#
#  index_subscriptions_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
