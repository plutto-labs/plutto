class AddUniqueIndexToMeterCounts < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    safety_assured {
      add_index :meter_counts, [:customer_id, :meter_id], unique: true
    }
  end
end
