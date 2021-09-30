class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments, id: :string do |t|
      t.references :payment_method, null: false, foreign_key: true, type: :string
      t.references :invoice, null: false, foreign_key: true, type: :string
      t.string :id_in_gateway
      t.integer :gateway
      t.jsonb :payment_data


      t.timestamps
    end
  end
end
