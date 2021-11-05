class Subscription < ApplicationRecord
  include PowerTypes::Observable

  has_many :billing_periods, dependent: :destroy
  has_many :pricing_subscriptions, dependent: :destroy
  has_many :pricings, through: :pricing_subscriptions
  has_many :products, through: :pricings
  has_many :price_logics, through: :pricings
  belongs_to :customer
  belongs_to :permission_group, optional: true

  delegate :country_iso_code, to: :customer, allow_nil: true

  enum currency: Currencies.keys
  enum bills_at: { start: 0, end: 1 }, _prefix: :bills_at, _default: :end
  enum price_type: { tax_inclusive: 0, tax_exclusive: 1 }, _suffix: true

  attribute :billing_period_duration, :duration

  validate :trial_finishes_at_is_valid_datetime
  validates :currency, :bills_at, :billing_period_duration, presence: true

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
    country = Countries.find_by('iso2', country_iso_code) ||
      Countries.find_by_currency(currency) # rubocop:disable Rails/DynamicFindBy
    country&.fetch('tax_rate', 0) || 0
  end

  def has_pricing?(pricings)
    pricings.any? { |pricing| self.pricings.include?(pricing) }
  end

  def display_name
    "#{id} - #{billing_period_duration.inspect} - #{currency} - #{price_type} - #{country_iso_code}"
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
#  bills_at                :integer          default("end"), not null
#  billing_period_duration :string           not null
#  country_iso_code        :integer          default(0), not null
#  currency                :integer
#  permission_group_id     :string
#
# Indexes
#
#  index_subscriptions_on_customer_id          (customer_id)
#  index_subscriptions_on_permission_group_id  (permission_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (permission_group_id => permission_groups.id)
#
