class ChangePlanAndPlanPermissionId < ActiveRecord::Migration[6.1]
  def change

    PermissionGroup.all.each do |permission_group|
      fake_group = PermissionGroup.create(name: 'fake', price_currency: 'USD', organization: Organization.first)

      permission_group.permission_group_permissions.each do |pgp|
        pgp.update(permission_group: fake_group)
      end
      permission_group.subscriptions.each do |subscription|
        subscription.update(permission_group: fake_group)
      end

      permission_group.update(id: permission_group.id.gsub('plan', 'permission-group'))

      fake_group.permission_group_permissions.each do |pgp|
        pgp.update(permission_group: permission_group)
      end
      fake_group.subscriptions.each do |subscription|
        subscription.update(permission_group: permission_group)
      end

      fake_group.destroy
    end


    PermissionGroupPermission.all.each do |pgp|
      pgp.update(id: pgp.id.gsub('plan-permission', 'permission-group-permission'))
    end
  end
end
