class PermissionGroupPermission < ApplicationRecord
  belongs_to :permission_group
  belongs_to :permission

  private

  def generate_id
    init_id('plan-permission')
  end
end

# == Schema Information
#
# Table name: permission_group_permissions
#
#  id                  :string           not null, primary key
#  permission_group_id :string           not null
#  permission_id       :string           not null
#  limit               :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_permission_group_permissions_on_permission_group_id  (permission_group_id)
#  index_permission_group_permissions_on_permission_id        (permission_id)
#
# Foreign Keys
#
#  fk_rails_...  (permission_group_id => permission_groups.id)
#  fk_rails_...  (permission_id => permissions.id)
#
