class AddBillingInformationToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :billing_information, :jsonb
  end
end
