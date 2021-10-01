class PriceLogic::Tiered < PriceLogic
  has_many :tiers, -> { order('index') }, as: :tierable, dependent: :destroy, inverse_of: :tierable
  accepts_nested_attributes_for :tiers, allow_destroy: true

  validates :meter_count_method, presence: true

  NAME = 'tiered'

  def calculate_price(n_units = 0)
    remaining_units = n_units
    total_price = Money.new(0, price_currency)
    tiers.order(index: :asc).each_with_index do |tier, index|
      break if remaining_units <= 0

      if index == tiers.count - 1
        total_price += remaining_units * tier.price
      else
        total_price += [remaining_units, tier.units_in_tier].min * tier.price
        remaining_units -= tier.units_in_tier
      end
    end

    total_price
  end

  def metered?
    true
  end

  private

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
