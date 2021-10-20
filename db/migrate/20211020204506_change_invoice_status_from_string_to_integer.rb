class ChangeInvoiceStatusFromStringToInteger < ActiveRecord::Migration[6.1]
  def change
    safety_assured {
      remove_column :invoices, :status, :string
      add_column :invoices, :status, :integer, default: 0
    }
  end
end
