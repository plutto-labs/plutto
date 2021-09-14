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

  organizations = ['Plutto', 'Platanus']

  organizations.each do |organization_name|
    org = Organization.find_or_create_by(name: organization_name)


    plutto_user_mails.each do |email|
      User.find_or_create_by(email: email) do |user|
        user.password = 'password'
        user.organization = org
      end

      AdminUser.find_or_create_by(email: email) do |user|
        user.password = 'password'
      end
    end

    meter = Meter.find_or_create_by(name: 'api calls', organization: org)

    plan = Plan.find_or_create_by(name: 'Enterprise', organization: org) do |plan|
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

    customers.each do |customer_info|
      Customer.includes(:billing_information).find_or_create_by(
        email: customer_info[0],name: customer_info[1], organization: org
        ) do |customer|
        BillingInformation.create(
          customer: customer,
          city: 'Santiago',
          country_iso_code: 'CHL',
          state: 'Metropolitana',
          address: 'Av. Las Condes',
          zip: '12345',
          tax_id: '73245432-1',
          phone: '9550898',
          legal_name: 'Plutto Inc',
        )
        plan_subscription = PlanSubscription.find_or_create_by(customer: customer,
          plan_version: plan_version, active: true)

        billing_period = BillingPeriod.find_or_create_by(
          plan_subscription: plan_subscription,
          from: DateTime.new(2021, 7, 7),
          to: DateTime.new(2021, 8, 7),
          billing_date: DateTime.new(2021, 8, 8)
        )

        Invoice.find_or_create_by(
          currency: 'usd',
          subtotal_cents: 10000,
          tax_cents: 190,
          discount_cents: 0,
          issue_date: DateTime.new(2021, 8, 7),
          details: {
            '0': { type: 'flat_fee',
                total_price_cents: 100 },
            '1': { type: 'volume',
                total_price_cents: 25000,
                meter: 'Requests',
                quantity: 250.0 }
          },
          billing_period: billing_period,
          customer: customer,
          state: 'paid',
          payed_at: DateTime.new(2021, 9, 7),
          payment_method: 'bank_transfer',
          tax_type: 'VAT',
          billing_information: customer.billing_information.as_json
        )
      end
    end
  end
end
