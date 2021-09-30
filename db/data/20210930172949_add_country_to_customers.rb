# frozen_string_literal: true

class AddCountryToCustomers < ActiveRecord::Migration[6.1]
  def up
    Customer.all.each do |customer|
      unless customer.billing_information
        billing_information = BillingInformation.create(
          customer: customer,
          city: '',
          country_iso_code: 'CL',
          state: '',
          address: '',
          zip: '',
          tax_id: '',
          phone: '',
          legal_name: '',
        )
      end
    end
  end

  def down; end
end
