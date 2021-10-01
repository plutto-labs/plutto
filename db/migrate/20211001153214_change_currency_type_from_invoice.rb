class ChangeCurrencyTypeFromInvoice < ActiveRecord::Migration[6.1]
  def up
    safety_assured do
      change_column_default :pricings, :currency, nil
      add_column :invoices, :temp_currency, :integer
      Invoice.all.each { |i| i.update(temp_currency: i.currency) }
      remove_column :invoices, :currency, :string
      rename_column :invoices, :temp_currency, :currency
    end
  end

  def down
    safety_assured do
      rename_column :invoices, :currency, :temp_currency
      add_column :invoices, :currency, :string
      Invoice.all.each { |i| i.update(currency: i.temp_currency) }
      remove_column :invoices, :temp_currency, :integer
      change_column_default :pricings, :currency, 0
    end
  end
end
