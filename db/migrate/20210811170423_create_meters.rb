class CreateMeters < ActiveRecord::Migration[6.1]
  def change
    create_table :meters, id: :string do |t|
      t.string :name
      t.references :organization, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
