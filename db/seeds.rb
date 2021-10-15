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

def self.with_disabled_observers(&block)
  PowerTypes::Observable.observable_disabled = true
  block.call
  PowerTypes::Observable.observable_disabled = false
end

with_disabled_observers do
  unless Rails.env.production?
    plutto_user_mails = ['felipe@getplutto.com', 'antonia@getplutto.com',
                        'sebastian@getplutto.com', 'ignacio@getplutto.com']

    customers = (1..200).map { [Faker::Internet.email, Faker::Name.name] }

    organizations = ['Plutto', 'Platanus']

    p 'Setting organizations... Go and grab a coffee, this takes a while...'
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
      pricings = ['USD', 'CLP'].map do |currency|
        Pricing.find_or_create_by(name: 'Enterprise', product: product, currency: currency) do |pricing|
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
      end

      p 'Creating customers...'

      customers.each do |customer_info|
        date = rand(365.days).seconds.ago

        Customer.includes(:billing_information).find_or_create_by(
          email: customer_info[0], name: customer_info[1], organization: org) do |customer|
            customer.created_at = date
            customer.save

          pricing = pricings.sample

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
            trial_finishes_at: nil,
            bills_at: 'end',
            currency: pricing.currency,
            created_at: date,
          )

          PricingSubscription.create(
            subscription: subscription,
            pricing: pricing
          )

          (date.to_date..Date.current.to_date).step(30).each do |billing_period_date|
            if rand(2) == 1
              billing_period = BillingPeriod.find_or_create_by(
                subscription: subscription,
                from: billing_period_date,
                to: billing_period_date + 1.month,
                billing_date: billing_period_date + 1.month,
                created_at: billing_period_date
              )

              if date + 1.month < Date.today
                Invoice.create(
                  customer: customer,
                  billing_information: customer.billing_information.as_json,
                  billing_period: billing_period,
                  issue_date: billing_period_date + 1.month,
                  details: [{"id"=>"price-logic_db7f2764d4aa3fd6e8abd805", "type"=>"flat_fee", "description"=>"flat_fee", "total_price"=>900}],
                  subtotal_cents: rand(1000..10000),
                  currency: pricing.currency,
                  created_at: billing_period_date + 1.month,
                  status: ['paid', 'not_paid', 'voided'].sample,
                )
              end
            end
          end
        end
      end
    end
  end
end
