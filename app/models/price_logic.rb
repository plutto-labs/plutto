class PriceLogic < ApplicationRecord
  NAME = 'not_defined'

  belongs_to :pricing

  validates :type, presence: true
  before_validation :set_lower_limits, on: :create, if: -> { respond_to?(:tiers) }
  before_validation :set_currency

  monetize :price_cents

  enum meter_count_method: { period_sum: 0, history_sum: 1 }

  def calculate_price(n_units = 0)
    raise NotImplementedError
  end

  def metered?
    raise NotImplementedError
  end

  def meter
    return unless metered?

    pricing.meter
  end

  private

  def set_lower_limits
    tiers.each_with_index do |tier, index|
      tier.lower_limit = index.zero? ? 1 : tiers[index - 1].upper_limit + 1
    end
  end

  def set_currency
    self.price_currency = pricing.currency
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
#  meter_id           :string
#  meter_count_method :integer
#  pricing_id         :string           not null
#
# Indexes
#
#  index_price_logics_on_meter_id    (meter_id)
#  index_price_logics_on_pricing_id  (pricing_id)
#
# Foreign Keys
#
#  fk_rails_...  (meter_id => meters.id)
#  fk_rails_...  (pricing_id => pricings.id)
#
