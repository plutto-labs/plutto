# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Write the code in a way that can be executed multiple times without duplicating the information.
#
# For example:
#
# Country.create(name: "Chile") # BAD
# Country.find_or_create_by(name: "Chile") # GOOD
#

unless Rails.env.production?
  plutto_user_mails = ['felipe@getplutto.com', 'antonia@getplutto.com',
                       'sebastian@getplutto.com', 'ignacio@getplutto.com']
  customers = ['donald@mars.com', 'ham@platan.us', 'teddy@apple.com']

  plutto = Organization.find_or_create_by(name: 'Plutto')

  plutto_user_mails.each do |email|
    User.find_or_create_by(email: email) do |user|
      user.password = 'password'
      user.organization = plutto
    end

    AdminUser.find_or_create_by(email: email) do |user|
      user.password = 'password'
    end
  end

  meter = Meter.find_or_create_by(name: 'api calls', organization: plutto) do |meter|
    meter.meter_type = 'history_sum'
  end

  customers.each do |customer|
    Customer.find_or_create_by(email: customer, organization: plutto)
  end

  plan = Plan.find_or_create_by(name: 'Plutto', organization: plutto) do |plan|
    plan.currency = 'USD'
  end

  plan_version = PlanVersion.find_or_create_by(plan: plan) do |plan_version|
    plan_version.deployed = true
    plan.default_version = plan_version
  end

  if plan_version
    PriceLogic::FlatFee.find_or_create_by(plan_version: plan_version) do |flat_fee|
      flat_fee.price = Money.new(100, plan.currency)
    end

    PriceLogic::PerUnit.find_or_create_by(plan_version: plan_version, meter: meter) do |per_unit|
      per_unit.price = Money.new(5, plan.currency)
    end
  end
end
