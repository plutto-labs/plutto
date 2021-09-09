class AddInfoToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :payed_at, :datetime
    add_column :invoices, :payment_method, :integer
    add_column :invoices, :tax_type, :integer
    add_column :invoices, :document_id, :integer
  end
end
