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

    pricing = Pricing.find_or_create_by(name: 'Enterprise', organization: org)

    if pricing
      PriceLogic::FlatFee.find_or_create_by(pricing: pricing) do |flat_fee|
        flat_fee.price = Money.new(100, pricing.currency)
        flat_fee.meter_count_method = 'period_sum'
      end

      PriceLogic::PerUnit.find_or_create_by(pricing: pricing, meter: meter) do |per_unit|
        per_unit.price = Money.new(5, pricing.currency)
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

        # TODO: fix this
        subscription = Subscription.find_or_create_by(
          customer: customer,
          pricings: [pricing], active: true,
          currency: 'USD',
          bills_at: 'end',
          billing_period_duration: 1.month
        )

        billing_period = BillingPeriod.find_or_create_by(
          subscription: subscription,
          from: DateTime.new(2021, 7, 7),
          to: DateTime.new(2021, 8, 7),
          billing_date: DateTime.new(2021, 8, 8)
        )

        Invoice.find_or_create_by(
          currency: 'usd',
          subtotal_cents: 10000,
          total_cents: 10190,
          tax_cents: 190,
          discount_cents: 0,
          issue_date: DateTime.new(2021, 8, 7),
          details: {
            '0': { type: 'flat_fee',
                total_price: 100 },
            '1': { type: 'volume',
                total_price: 25000,
                meter: 'Requests',
                quantity: 250.0 }
          },
          billing_period: billing_period,
          customer: customer,
          status: 'paid',
          payed_at: DateTime.new(2021, 9, 7),
          payment_method: 'bank_transfer',
          tax_type: 'VAT',
          billing_information: customer.billing_information.as_json
        )
      end
    end
  end
end
