class CreateMeterEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :meter_events, id: :string do |t|
      t.datetime :timestamp, null: false
      t.float :amount, default: 1.0
      t.integer :action, default: 0
      t.references :meter, null: false, foreign_key: true, type: :string
      t.references :customer, null: false, foreign_key: true, type: :string
      t.references :meter_count, null: false, foreign_key: true, type: :string

      t.timestamps

      t.index :action
    end
  end
end
