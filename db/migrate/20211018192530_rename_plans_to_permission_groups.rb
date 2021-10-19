class RenamePlansToPermissionGroups < ActiveRecord::Migration[6.1]
  def change
    safety_assured {
      rename_table :plans, :permission_groups
      rename_column :plan_permissions, :plan_id, :permission_group_id
      rename_column :subscriptions, :plan_id, :permission_group_id
    }
  end
end
