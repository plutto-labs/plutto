class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers, id: :string do |t|
      t.string :email, null: false
      t.string :name
      t.jsonb :customer_info, default: {}
      t.references :organization, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
