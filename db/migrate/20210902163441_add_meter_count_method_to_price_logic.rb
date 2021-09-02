class AddMeterCountMethodToPriceLogic < ActiveRecord::Migration[6.1]
  def change
    add_column :price_logics, :meter_count_method, :integer, null: false
  end
end
