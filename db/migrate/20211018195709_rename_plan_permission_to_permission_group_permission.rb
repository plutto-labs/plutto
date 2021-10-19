class RenamePlanPermissionToPermissionGroupPermission < ActiveRecord::Migration[6.1]
  def change
    safety_assured {
      rename_table :plan_permissions, :permission_group_permissions
    }
  end
end
