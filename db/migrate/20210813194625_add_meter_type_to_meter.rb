class AddMeterTypeToMeter < ActiveRecord::Migration[6.1]
  def change
    add_column :meters, :meter_type, :integer, null: false
  end
end
