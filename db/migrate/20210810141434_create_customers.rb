class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.string :email, null: false
      t.string :name
      t.jsonb :customer_info, default: {}
      t.string :identifier, null: false
      t.references :organization, null: false, foreign_key: true

      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
