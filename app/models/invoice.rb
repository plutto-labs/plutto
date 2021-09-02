class Invoice < ApplicationRecord
  belongs_to :billing_period

  monetize :subtotal_cents, with_model_currency: :currency
  monetize :tax_cents, :discount_cents, allow_nil: true, with_model_currency: :currency

  private

  def set_currency
    self.currency = billing_period.plan_subscription.plan_version.currency
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                :string           not null, primary key
#  subtotal_cents    :bigint(8)        default(0), not null
#  tax_cents         :bigint(8)        default(0), not null
#  discount_cents    :bigint(8)        default(0), not null
#  currency          :string           default("usd")
#  issue_date        :datetime
#  details           :jsonb
#  billing_period_id :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_invoices_on_billing_period_id  (billing_period_id)
#
# Foreign Keys
#
#  fk_rails_...  (billing_period_id => billing_periods.id)
#
