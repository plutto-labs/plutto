class CreateMeters < ActiveRecord::Migration[6.1]
  def change
    create_table :meters do |t|
      t.string :name
      t.string :identifier
      t.references :organization, null: false, foreign_key: true

      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
