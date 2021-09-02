class PriceLogic::FlatFee < PriceLogic
  NAME = 'flat_fee'

  def calculate_price(_n_units = 0)
    price
  end

  def self.metered?
    false
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
#  plan_version_id    :string           not null
#  price_cents        :bigint(8)        default(0), not null
#  price_currency     :string           default("USD"), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  meter_id           :string
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
