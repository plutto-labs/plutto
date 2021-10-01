class DeleteUnusedReference < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :price_logics, :meter_id, :string }
  end
end
