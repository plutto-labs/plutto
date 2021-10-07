class Permission < ApplicationRecord
  belongs_to :organization
  has_one :plan_permission, dependent: :destroy
  has_one :plan, through: :plan_permission
  belongs_to :meter, optional: true

  private

  def generate_id
    init_id('permission')
  end
end

# == Schema Information
#
# Table name: permissions
#
#  id                 :string           not null, primary key
#  name               :string
#  meter_id           :string           not null
#  meter_count_method :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  organization_id    :string           not null
#
# Indexes
#
#  index_permissions_on_meter_id         (meter_id)
#  index_permissions_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (meter_id => meters.id)
#  fk_rails_...  (organization_id => organizations.id)
#
