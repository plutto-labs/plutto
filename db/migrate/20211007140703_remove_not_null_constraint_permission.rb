class RemoveNotNullConstraintPermission < ActiveRecord::Migration[6.1]
  def change
    safety_assured {
      change_column :permissions, :meter_id, :string, null: true
    }
  end
end
