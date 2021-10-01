class PriceLogic::PerUnit < PriceLogic
  validates :meter_count_method, presence: true

  NAME = 'per_unit'

  def calculate_price(n_units = 0)
    price * n_units
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
