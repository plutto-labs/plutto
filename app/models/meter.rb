class Meter < ApplicationRecord
  include IdentifierAttribute

  has_many :meter_events, dependent: :nullify
  has_many :price_logics, dependent: :destroy
  belongs_to :organization

  validates :identifier, uniqueness: true
  validates :meter_type, presence: true

  before_create :generate_identifier

  enum meter_type: { period_sum: 0, history_sum: 1 }

  private

  def generate_identifier
    init_identifier('meter')
  end
end

# == Schema Information
#
# Table name: meters
#
#  id              :bigint(8)        not null, primary key
#  name            :string
#  identifier      :string
#  organization_id :bigint(8)        not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  meter_type      :integer          not null
#
# Indexes
#
#  index_meters_on_identifier       (identifier) UNIQUE
#  index_meters_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
