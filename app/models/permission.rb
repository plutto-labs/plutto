class Permission < ApplicationRecord
  belongs_to :organization
  has_many :permission_group_permissions, dependent: :destroy
  has_many :permission_groups, through: :permission_group_permissions
  belongs_to :meter, optional: true

  enum meter_count_method: { period_sum: 0, history_sum: 1 }
  validates :meter_id, presence: true, if: :meter_count_method
  validates :meter_count_method, presence: true, if: :meter_id
  validates :name, uniqueness: { scope: :organization_id }

  def metered?
    !meter.nil?
  end

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
#  meter_id           :string
#  meter_count_method :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  organization_id    :string           not null
#
# Indexes
#
#  index_permissions_on_meter_id                  (meter_id)
#  index_permissions_on_name_and_organization_id  (name,organization_id) UNIQUE
#  index_permissions_on_organization_id           (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (meter_id => meters.id)
#  fk_rails_...  (organization_id => organizations.id)
#
