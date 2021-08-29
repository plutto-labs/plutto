class BillingPeriod < ApplicationRecord
  include IdentifierAttribute

  has_many :meter_events, dependent: :destroy
  has_many :billing_period_meter_datas, dependent: :destroy
  belongs_to :plan_subscription

  delegate :plan_version_price_logics, to: :plan_subscription

  validates :identifier, uniqueness: true

  before_create :generate_identifier

  monetize :billing_amount_cents

  private

  def generate_identifier
    init_identifier('period')
  end
end

# == Schema Information
#
# Table name: billing_periods
#
#  id                      :bigint(8)        not null, primary key
#  from                    :datetime         not null
#  to                      :datetime         not null
#  identifier              :string
#  plan_subscription_id    :bigint(8)        not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  billing_date            :datetime
#  billing_amount_cents    :bigint(8)        default(0), not null
#  billing_amount_currency :string           default("USD"), not null
#
# Indexes
#
#  index_billing_periods_on_identifier            (identifier) UNIQUE
#  index_billing_periods_on_plan_subscription_id  (plan_subscription_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_subscription_id => plan_subscriptions.id)
#
