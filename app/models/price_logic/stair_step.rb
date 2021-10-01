class PriceLogic::StairStep < PriceLogic
  has_many :tiers, -> { order('index') }, as: :tierable, dependent: :destroy, inverse_of: :tierable
  accepts_nested_attributes_for :tiers, allow_destroy: true

  validates :meter_count_method, presence: true

  NAME = 'stair_step'

  def calculate_price(units)
    return Money.new(0, price_currency) if units <= 0

    tier = tier_for_units(units)
    tier.price
  end

  def metered?
    true
  end

  private

  def tier_for_units(units)
    tiers.each do |tier|
      return tier if tier.units_in_tier_range?(units)
    end

    tiers.last
  end

  def generate_id
    init_id('price-logic')
  end
end

# == Schema Information
#
# Table name: price_logics
#
#  id                 :string           not null, primary key
#  type               :string           not null
#  price_cents        :bigint(8)        default(0), not null
#  price_currency     :string           default("USD"), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  meter_count_method :integer
#  pricing_id         :string           not null
#
# Indexes
#
#  index_price_logics_on_pricing_id  (pricing_id)
#
# Foreign Keys
#
#  fk_rails_...  (pricing_id => pricings.id)
#
