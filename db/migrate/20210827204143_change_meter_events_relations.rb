class ChangeMeterEventsRelations < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    safety_assured {
      add_reference :meter_events, :billing_period, index: true, type: :string
      add_foreign_key :meter_events, :billing_periods
      remove_column :meter_events, :customer_id
    }
  end
end
