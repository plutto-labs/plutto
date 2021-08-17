class PriceLogic::StairStep < PriceLogic
  has_many :tiers, as: :tierable, dependent: :destroy

  NAME = 'stair_step'

  def calculate_price(units)
    tier = tier_for_units(units)
    tier.price
  end

  private

  def tier_for_units(units)
    tiers.each do |tier|
      return tier if tier.units_in_tier_range?(units)
    end

    tiers.last
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
