class AddMeterEventsColumns < ActiveRecord::Migration[6.1]
  def change
    add_column :meter_events, :idempotency_key, :string
    add_column :meter_events, :current_meter_count, :float
  end
end
