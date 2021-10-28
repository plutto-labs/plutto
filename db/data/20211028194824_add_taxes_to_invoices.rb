class AddTaxesToInvoices < ActiveRecord::Migration[6.1]
  def up
    Invoice.find_each do |invoice|
      tax_rate = invoice.billing_period&.subscription&.tax_rate || 0
      invoice.tax = invoice.net * tax_rate
      invoice.total = invoice.net + invoice.tax
      invoice.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
