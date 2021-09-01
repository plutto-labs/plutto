class Invoice < ApplicationRecord
  include IdentifierAttribute

  belongs_to :billing_period

  validates :identifier, uniqueness: true

  monetize :subtotal_cents, with_model_currency: :currency
  monetize :tax_cents, :discount_cents, allow_nil: true, with_model_currency: :currency

  before_create :generate_identifier, :set_currency

  private

  def generate_identifier
    init_identifier('invoice')
  end

  def set_currency
    self.currency = billing_period.plan_subscription.plan_version.currency
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                :bigint(8)        not null, primary key
#  identifier        :string
#  subtotal_cents    :bigint(8)        default(0), not null
#  tax_cents         :bigint(8)        default(0), not null
#  discount_cents    :bigint(8)        default(0), not null
#  currency          :string           default("usd")
#  issue_date        :datetime
#  details           :jsonb
#  billing_period_id :bigint(8)        not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_invoices_on_billing_period_id  (billing_period_id)
#  index_invoices_on_identifier         (identifier) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (billing_period_id => billing_periods.id)
#
