class PriceLogic::Tiered < PriceLogic
  has_many :tiers, -> { order('index') }, as: :tierable, dependent: :destroy, inverse_of: :tierable
  belongs_to :meter

  accepts_nested_attributes_for :tiers, allow_destroy: true

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

  def self.metered?
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
#  id                 :bigint(8)        not null, primary key
#  type               :string           not null
#  price_cents        :bigint(8)        default(0), not null
#  price_currency     :string           default("USD"), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  plan_version_id    :bigint(8)
#  meter_id           :bigint(8)
#  meter_count_method :integer          not null
#
# Indexes
#
#  index_price_logics_on_meter_id         (meter_id)
#  index_price_logics_on_plan_version_id  (plan_version_id)
#
# Foreign Keys
#
#  fk_rails_...  (meter_id => meters.id)
#  fk_rails_...  (plan_version_id => plan_versions.id)
#
