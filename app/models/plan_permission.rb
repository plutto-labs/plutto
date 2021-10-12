class PlanPermission < ApplicationRecord
  belongs_to :plan
  belongs_to :permission

  private

  def generate_id
    init_id('plan-permission')
  end
end

# == Schema Information
#
# Table name: plan_permissions
#
#  id            :string           not null, primary key
#  plan_id       :string           not null
#  permission_id :string           not null
#  limit         :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_plan_permissions_on_permission_id  (permission_id)
#  index_plan_permissions_on_plan_id        (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (permission_id => permissions.id)
#  fk_rails_...  (plan_id => plans.id)
#
