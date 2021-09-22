class CreatePaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_methods, id: :string do |t|
      t.references :customer, null: false, foreign_key: true, type: :string
      t.integer :gateway, null: false
      t.integer :category, null: false
      t.jsonb :gateway_info

      t.timestamps
    end
  end
end
