class PriceLogic::Tier < ApplicationRecord
  belongs_to :tierable, polymorphic: true

  validates :lower_limit, :upper_limit, :price_cents, :index, presence: true
  validates :upper_limit, numericality: { greater_than_or_equal_to: :lower_limit }
  validates :lower_limit, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_currency

  monetize :price_cents

  def units_in_tier
    upper_limit - lower_limit
  end

  def units_in_tier_range?(units)
    units >= lower_limit && units <= upper_limit
  end

  private

  def set_currency
    self.price_currency = tierable.price_currency
  end
end

# == Schema Information
#
# Table name: price_logic_tiers
#
#  id             :bigint(8)        not null, primary key
#  upper_limit    :float            not null
#  lower_limit    :float            not null
#  price_cents    :bigint(8)        default(0), not null
#  price_currency :string           default("USD"), not null
#  index          :integer          not null
#  tierable_type  :string
#  tierable_id    :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_price_logic_tiers_on_tierable  (tierable_type,tierable_id)
#
