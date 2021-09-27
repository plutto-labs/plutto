class AddNetAmountToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_monetize :invoices, :net, currency: { present: false }, amount: { default: 0 }
  end
end
