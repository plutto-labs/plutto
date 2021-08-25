require_relative '../support/identifier_factory_helper'

FactoryBot.define do
  extend IdentifierFactoryHelper
  factory :plan_version do
    plan
    previous_version { nil }
    deployed { false }
    version { 1 }
    sequence(:identifier) { |i| "version_#{i}" }
  end
end
