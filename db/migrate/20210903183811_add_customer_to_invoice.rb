class AddCustomerToInvoice < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    safety_assured do
      add_reference :invoices, :customer, foreign_key: true, index: true, type: :string, null: false
    end
    add_column :invoices, :aasm_state, :string, default: 'new'
  end
end
