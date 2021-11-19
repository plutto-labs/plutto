class PaymentMethod < ApplicationRecord
  belongs_to :customer

  enum currency: Currencies.keys
  enum gateway: { kushki: 0, mercadopago: 1 }
  enum category: { credit_card: 0 }
  enum card_brand: { mastercard: 0, visa: 1 }

  private

  def generate_id
    init_id('payment_method')
  end
end

# == Schema Information
#
# Table name: payment_methods
#
#  id            :string           not null, primary key
#  customer_id   :string           not null
#  gateway       :integer          not null
#  category      :integer          not null
#  gateway_info  :jsonb
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  currency      :integer
#  last_4_digits :string
#  card_brand    :integer
#
# Indexes
#
#  index_payment_methods_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
