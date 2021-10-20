class Invoice < ApplicationRecord
  default_scope { order(issue_date: :desc) }

  VALID_ACTIONS = {
    created: ['post', 'charge', 'void'],
    posted: ['post', 'charge', 'void'],
    paid: ['void'],
    not_paid: ['paid', 'void'],
    voided: []
  }

  belongs_to :billing_period
  belongs_to :customer
  has_one :payment, dependent: :destroy

  monetize :subtotal_cents, with_model_currency: :currency
  monetize :tax_cents, :discount_cents, :total_cents, :net_cents, allow_nil: true,
    with_model_currency: :currency

  enum currency: Currencies.keys
  enum status: { created: 0, posted: 1, paid: 2, not_paid: 3, voided: 4 }

  before_validation :set_invoice_data

  enum tax_type: { IVA: 0, VAT: 1 }, _suffix: true
  enum payment_method: { bank_transfer: 0, credit: 1 }, _suffix: true

  def self.ransackable_attributes(_auth_object = nil)
    ['status']
  end

  def change_status(new_status)
    return post! if new_status == 'post'
    return charge! if new_status == 'charge'
    return void! if new_status == 'void'
  end

  def post!
    invoice_service.post!
  end

  def charge!
    invoice_service.charge!
  end

  def void!
    invoice_service.void!
  end

  private

  def set_invoice_data
    self.net = subtotal - discount
    self.tax = net * tax_rate
    self.total = net + tax
  end

  def tax_rate
    billing_period&.subscription&.tax_rate || 0
  end

  def generate_id
    init_id('invoice')
  end

  def invoice_service
    @invoice_service ||= InvoiceService.new(invoice: self)
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
#  issue_date          :datetime
#  details             :jsonb
#  billing_period_id   :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  customer_id         :string           not null
#  payed_at            :datetime
#  payment_method      :integer
#  tax_type            :integer
#  document_id         :string
#  billing_information :jsonb
#  total_cents         :bigint(8)
#  net_cents           :bigint(8)        default(0), not null
#  currency            :integer
#  status              :integer          default("created")
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
