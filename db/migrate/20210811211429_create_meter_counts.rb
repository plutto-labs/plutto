class CreateMeterCounts < ActiveRecord::Migration[6.1]
  def change
    create_table :meter_counts, id: :string do |t|
      t.float :count, default: 0.0
      t.references :billing_period, null: false, foreign_key: true, type: :string
      t.references :meter, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
