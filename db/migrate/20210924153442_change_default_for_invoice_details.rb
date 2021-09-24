class ChangeDefaultForInvoiceDetails < ActiveRecord::Migration[6.1]
  def change
    change_column_default :invoices, :details, []
  end
end
