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
  customers = [
    ['donald@mars.com', 'Donald Mars'],
    ['ham@platan.us', 'Ham the Chimp'],
    ['teddy@apple.com', 'Teddy Apple']
  ]

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

  meter = Meter.find_or_create_by(name: 'api calls', organization: plutto)

  customers.each_with_index do |customer, index|
    Customer.find_or_create_by(organization: plutto, identifier: index) do |cust|
      BillingInformation.create(
        customer: cust
        city: 'Santiago',
        country_iso_code: 'Chile',
        state: 'Metropolitana',
        street: 'Av. Las Condes',
        zip: '12345',
        tax_id: '73245432-1',
        company_name:  'Plutto Inc',
      )
    end
  end

  plan = Plan.find_or_create_by(name: 'Plutto', organization: plutto) do |plan|
    plan.currency = 'USD'
    plan.bills_at = 'end'
    plan.billing_period_duration = 1.month
  end

  plan_version = PlanVersion.find_or_create_by(plan: plan) do |plan_version|
    plan_version.deployed = true
    plan.default_version = plan_version
  end

  if plan_version
    PriceLogic::FlatFee.find_or_create_by(plan_version: plan_version) do |flat_fee|
      flat_fee.price = Money.new(100, plan.currency)
      flat_fee.meter_count_method = 'period_sum'
    end

    PriceLogic::PerUnit.find_or_create_by(plan_version: plan_version, meter: meter) do |per_unit|
      per_unit.price = Money.new(5, plan.currency)
      per_unit.meter_count_method = 'period_sum'
    end
  end

  customers.each do |customer|
    Customer.find_or_create_by(email: customer, organization: plutto) do |cust|
      PlanSubscription.find_or_create_by(customer: cust, plan_version: plan_version, active: true)
    end
  end
end
