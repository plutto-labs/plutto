class BillingInformation < ApplicationRecord
  belongs_to :customer

  enum country_iso_code: Countries.codes

  private

  def generate_id
    init_id('billing-info')
  end
end

# == Schema Information
#
# Table name: billing_informations
#
#  id               :string           not null, primary key
#  legal_name       :string
#  state            :string
#  city             :string
#  address          :string
#  zip              :string
#  activity         :string
#  tax_id           :string
#  phone            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  customer_id      :string           not null
#  country_iso_code :integer
#
# Indexes
#
#  index_billing_informations_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
