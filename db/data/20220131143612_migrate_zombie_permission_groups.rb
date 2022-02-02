# frozen_string_literal: true

class MigrateZombiePermissionGroups < ActiveRecord::Migration[6.1]
  def up
    # zombie subscrptions
    zombie_permission_groups = ['permission-group_483d5d7e7a053f737a51b7fe', 'permission-group_c2003fdb3bb877119a02e3e0', 'permission-group_76cfebba5723ebc6bb54eba0', 'permission-group_341e5d4aec0ef6fbeed6927a']
    PermissionGroup.where(id: zombie_permission_groups).update_all(zombie: true)

    subscriptions = Subscription.where(permission_group_id: zombie_permission_groups)
    subscriptions.update_all(zombie: true)

    # delete invices
    subscriptions.each do |subscription|
      subscription.billing_periods.each do |bp|
        bp.invoice.destroy
      end
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
