require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
  factory :organization do
    name { 'Plutto' }
    sequence(:identifier) { |i| "organization_#{i}" }
  end
end
