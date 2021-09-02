class ChangeMeterCountsRelations < ActiveRecord::Migration[6.1]
  def change
    safety_assured {
      add_reference :meter_counts, :customer, index: true, null: false, type: :string
      add_foreign_key :meter_counts, :customers
      remove_column :meter_counts, :billing_period_id
    }
  end
end
