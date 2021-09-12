class ChangeStatusToInvoices < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      rename_column :invoices, :aasm_state, :status
    end
  end
end
