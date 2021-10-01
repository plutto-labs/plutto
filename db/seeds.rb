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
    product = Product.find_or_create_by(name: 'Plutto Billings', organization: org, meter: meter)
    pricing = Pricing.find_or_create_by(name: 'Enterprise', product: product, currency: 'USD')

    if pricing
      PriceLogic::FlatFee.find_or_create_by(pricing: pricing, price_currency: pricing.currency) do |flat_fee|
        flat_fee.price = Money.new(100, pricing.currency)
        flat_fee.meter_count_method = 'period_sum'
        flat_fee.price_currency = pricing.currency
      end

      PriceLogic::PerUnit.find_or_create_by(pricing: pricing, price_currency: pricing.currency) do |per_unit|
        per_unit.price = Money.new(5, pricing.currency)
        per_unit.meter_count_method = 'period_sum'
        per_unit.price_currency = pricing.currency
      end
    end

    customers.each do |customer_info|
      Customer.includes(:billing_information).find_or_create_by(
        email: customer_info[0],name: customer_info[1], organization: org) do |customer|
        BillingInformation.create(
          customer: customer,
          city: 'Santiago',
          country_iso_code: 'CL',
          state: 'Metropolitana',
          address: 'Av. Las Condes',
          zip: '12345',
          tax_id: '73245432-1',
          phone: '9550898',
          legal_name: 'Plutto Inc',
        )

        subscription = Subscription.create!(
          customer: customer,
          active: true,
          billing_period_duration: 'P1M',
          trial_finishes_at: Time.now + 1.month,
          bills_at: 'end',
          currency: pricing.currency
        )

        PricingSubscription.create(
          subscription: subscription,
          pricing: pricing
        )

        billing_period = BillingPeriod.find_or_create_by(
          subscription: subscription,
          from: DateTime.current - 1.month,
          to: DateTime.current,
          billing_date: DateTime.current,
        )
      end
    end
  end
end
