class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :identifier
      t.monetize :subtotal, null: false, currency: { present: false }
      t.monetize :tax, currency: { present: false }
      t.monetize :discount, currency: { present: false }
      t.string :currency, default: :usd
      t.datetime :issue_date
      t.jsonb :details, default: {}
      t.references :billing_period, null: false, foreign_key: true, index: true

      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
