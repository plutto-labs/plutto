require_relative '../../support/tiers_factory_helper'

FactoryBot.define do
  extend TiersFactoryHelper

  factory :price_logic_volume, class: 'PriceLogic::Volume' do
    plan_version
  end
end
