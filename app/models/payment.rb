class Payment < ApplicationRecord
  belongs_to :payment_method
  belongs_to :invoice

  enum gateway: { kushki: 0 }
end

# == Schema Information
#
# Table name: payments
#
#  id                :string           not null, primary key
#  payment_method_id :string           not null
#  invoice_id        :string           not null
#  id_in_gateway     :string
#  gateway           :integer
#  payment_data      :jsonb
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_payments_on_invoice_id         (invoice_id)
#  index_payments_on_payment_method_id  (payment_method_id)
#
# Foreign Keys
#
#  fk_rails_...  (invoice_id => invoices.id)
#  fk_rails_...  (payment_method_id => payment_methods.id)
#
