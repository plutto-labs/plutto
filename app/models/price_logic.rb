class PriceLogic < ApplicationRecord
  NAME = 'not_defined'

  belongs_to :plan_version

  validates :type, presence: true

  monetize :price_cents

  def calculate_price(n_units = 0)
    raise NotImplementedError
  end
end

# == Schema Information
#
# Table name: price_logics
#
#  id              :bigint(8)        not null, primary key
#  type            :string           not null
#  price_cents     :bigint(8)        default(0), not null
#  price_currency  :string           default("USD"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  plan_version_id :bigint(8)
#
# Indexes
#
#  index_price_logics_on_plan_version_id  (plan_version_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_version_id => plan_versions.id)
#
