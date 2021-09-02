class Meter < ApplicationRecord
  has_many :meter_events, dependent: :nullify
  has_many :meter_counts, dependent: :destroy
  has_many :price_logics, dependent: :destroy
  belongs_to :organization

  private

  def generate_id
    init_id('meter')
  end
end

# == Schema Information
#
# Table name: meters
#
#  id              :string           not null, primary key
#  name            :string
#  organization_id :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_meters_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
