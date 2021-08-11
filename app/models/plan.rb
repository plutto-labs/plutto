class Plan < ApplicationRecord
  include IdentifierAttribute

  has_many :plan_versions, dependent: :destroy
  belongs_to :organization

  validates :identifier, uniqueness: true

  before_create :generate_identifier

  private

  def generate_identifier
    init_identifier('plan')
  end
end

# == Schema Information
#
# Table name: plans
#
#  id              :bigint(8)        not null, primary key
#  name            :string
#  identifier      :string           not null
#  organization_id :bigint(8)        not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_plans_on_identifier       (identifier) UNIQUE
#  index_plans_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#