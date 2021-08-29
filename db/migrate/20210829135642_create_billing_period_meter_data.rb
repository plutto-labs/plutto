class CreateBillingPeriodMeterData < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_period_meter_data do |t|
      t.float :initial_count, default: 0.0
      t.float :final_count
      t.references :billing_period, null: false, foreign_key: true
      t.references :meter_count, null: false, foreign_key: true
      t.index [:meter_count_id, :billing_period_id], unique: true, name: 'index_on_meter_count_id_and_billing_period_id'

      t.timestamps
    end
  end
end
