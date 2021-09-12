class Invoice < ApplicationRecord
  include AASM
  include PowerTypes::Observable

  belongs_to :billing_period
  belongs_to :customer

  monetize :subtotal_cents, with_model_currency: :currency
  monetize :tax_cents, :discount_cents, allow_nil: true, with_model_currency: :currency

  aasm(column: :status) do
    state :new, initial: true
    state :posted, :paid, :not_paid, :voided

    event :post do
      transitions from: :new, to: :posted
    end

    event :charge do
      transitions from: [:posted], to: :paid
    end

    event :fail do
      transitions from: [:new, :posted], to: :not_paid
    end

    event :void do
      transitions from: [:new, :posted, :not_paid], to: :voided
    end
  end

  enum tax_type: { IVA: 0, VAT: 1 }, _suffix: true
  enum payment_method: { bank_transfer: 0, credit: 1 }, _suffix: true

  private

  def set_currency
    self.currency = billing_period.plan_subscription.plan_version.currency
  end

  def generate_id
    init_id('invoice')
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                  :string           not null, primary key
#  subtotal_cents      :bigint(8)        default(0), not null
#  tax_cents           :bigint(8)        default(0), not null
#  discount_cents      :bigint(8)        default(0), not null
#  currency            :string           default("usd")
#  issue_date          :datetime
#  details             :jsonb
#  billing_period_id   :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  customer_id         :string           not null
#  status              :string           default("new")
#  payed_at            :datetime
#  payment_method      :integer
#  tax_type            :integer
#  document_id         :integer
#  billing_information :jsonb
#
# Indexes
#
#  index_invoices_on_billing_period_id  (billing_period_id)
#  index_invoices_on_customer_id        (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (billing_period_id => billing_periods.id)
#  fk_rails_...  (customer_id => customers.id)
#
