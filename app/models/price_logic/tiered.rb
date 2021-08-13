class PriceLogic::Tiered < PriceLogic
  has_many :tiers, as: :tierable, dependent: :destroy

  NAME = 'tiered'

  def calculate_price(n_units = 0)
    remaining_units = n_units
    total_price = 0
    tiers.order(index: :asc).each do |tier|
      break if remaining_units <= 0

      total_price +=
        (n_units >= tier.upper_limit ? tier.units_in_tier : remaining_units) * tier.price
      remaining_units -= tier.units_in_tier
    end

    total_price
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
