class ChangePlanPermissionLimitType < ActiveRecord::Migration[6.1]
  def change
    safety_assured {
      change_column :plan_permissions, :limit, :float
    }
  end
end
