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
