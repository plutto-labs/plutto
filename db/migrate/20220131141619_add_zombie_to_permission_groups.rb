class AddZombieToPermissionGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :permission_groups, :zombie, :boolean, default: false
    add_column :subscriptions, :zombie, :boolean, default: false
  end
end
