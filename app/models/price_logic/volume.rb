class PriceLogic::Volume < PriceLogic
  has_many :tiers, as: :tierable, dependent: :destroy

  NAME = 'Volume'

  def calculate_price(units)
    tier = tier_for_units(units)
    units * tier.price
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
#  id             :bigint(8)        not null, primary key
#  type           :string           not null
#  price_cents    :bigint(8)        default(0), not null
#  price_currency :string           default("USD"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
