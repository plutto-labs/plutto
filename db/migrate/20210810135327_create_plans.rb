class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :identifier, null: false
      t.references :organization, null: false, foreign_key: true

      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
