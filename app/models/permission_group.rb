class PermissionGroup < ApplicationRecord
  belongs_to :organization
  has_many :permission_group_permissions, dependent: :destroy
  has_many :permissions, through: :permission_group_permissions
  has_many :subscriptions, dependent: :nullify

  accepts_nested_attributes_for :permission_group_permissions, allow_destroy: true

  enum price_currency: Currencies.keys
  monetize :price_cents
  validates :price_currency, presence: true

  private

  def generate_id
    init_id('plan')
  end
end

# == Schema Information
#
# Table name: permission_groups
#
#  id              :string           not null, primary key
#  name            :string
#  price_cents     :bigint(8)        default(0), not null
#  price_currency  :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :string           not null
#
# Indexes
#
#  index_permission_groups_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
