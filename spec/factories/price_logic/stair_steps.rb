require_relative '../../support/tiers_factory_helper'

FactoryBot.define do
  extend TiersFactoryHelper

  factory :price_logic_stair_step, class: 'PriceLogic::StairStep' do
    pricing
    meter_count_method { 'period_sum' }
  end
end
