require_relative '../support/organizations_factory_helper'

FactoryBot.define do
  extend OrganizationsFactoryHelper

  factory :organization do
    name { 'Plutto' }
    settings do
      { send_invoices_automatically: false, charge_invoices_automatically: false }
    end
  end
end
