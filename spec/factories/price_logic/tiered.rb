require_relative '../../support/tiers_factory_helper'

FactoryBot.define do
  extend TiersFactoryHelper

  factory :price_logic_tiered, class: 'PriceLogic::Tiered' do
  end
end
