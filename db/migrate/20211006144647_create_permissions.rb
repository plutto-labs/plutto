class CreatePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :permissions, id: :string do |t|
      t.string :name
      t.references :meter, null: false, foreign_key: true, type: :string
      t.integer :meter_count_method

      t.timestamps
    end
  end
end
