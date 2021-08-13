class CreateMeterCounts < ActiveRecord::Migration[6.1]
  def change
    create_table :meter_counts do |t|
      t.float :count, default: 0.0
      t.string :identifier
      t.references :billing_period, null: false, foreign_key: true
      t.references :meter, null: false, foreign_key: true

      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
