class CreateMeterEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :meter_events do |t|
      t.datetime :timestamp, null: false
      t.float :amount, default: 1.0
      t.integer :action, default: 0
      t.string :identifier
      t.references :meter, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.references :meter_count, null: false, foreign_key: true

      t.timestamps

      t.index :action
      t.index :identifier, unique: true
    end
  end
end
