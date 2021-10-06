class Plan < ApplicationRecord
  belongs_to :organization
  has_many :plan_permissions, dependent: :destroy
  has_many :permissions, through: :plan_permissions

  accepts_nested_attributes_for :plan_permissions, allow_destroy: true

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
# Table name: plans
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
#  index_plans_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
