class PriceLogic::Tier < ApplicationRecord
  belongs_to :tierable, polymorphic: true

  validates :lower_limit, :upper_limit, :price_cents, :index, presence: true
  validates :upper_limit, numericality: {
    greater_than_or_equal_to: ->(tier) { tier.lower_limit.to_f }
  }
  validates :lower_limit, numericality: { greater_than_or_equal_to: 1 }

  before_validation :set_currency

  monetize :price_cents

  def units_in_tier
    upper_limit - lower_limit + 1
  end

  def units_in_tier_range?(units)
    units >= lower_limit && units <= upper_limit
  end

  private

  def set_currency
    self.price_currency = tierable.price_currency
  end

  def generate_id
    init_id('tier')
  end
end

# == Schema Information
#
# Table name: price_logic_tiers
#
#  id             :string           not null, primary key
#  upper_limit    :float            not null
#  lower_limit    :float            not null
#  price_cents    :bigint(8)        default(0), not null
#  price_currency :string           default("USD"), not null
#  index          :integer          not null
#  tierable_type  :string
#  tierable_id    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_price_logic_tiers_on_tierable  (tierable_type,tierable_id)
#
