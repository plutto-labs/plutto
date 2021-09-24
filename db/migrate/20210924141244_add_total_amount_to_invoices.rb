class AddTotalAmountToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_monetize :invoices, :total, currency: { present: false }, amount: { null: true, default: nil }
  end
end
