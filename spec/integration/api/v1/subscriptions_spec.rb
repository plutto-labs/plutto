require 'swagger_helper'

describe 'API V1 Subscription', swagger_doc: 'v1/swagger.json' do
  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, organization: organization) }
  let(:products) { create_list(:product, 2, organization: organization) }
  let(:api_key) { create(:api_key, bearer: organization) }
  let!(:token) { api_key.token }
  let!(:pricings) do
    [
      create(:pricing, product: products[0], currency: 'USD'),
      create(:pricing, product: products[1], currency: 'USD')
    ]
  end

  path '/api/v1/subscriptions' do
    post 'Creates Subscription' do
      tags 'Subscription'
      description "Creates Subscription for one or more products \n\n"\
       "Make sure pricing_ids is NOT NULL."
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]
      parameter name: :subscription, in: :body,
                schema: { '$ref': '#/components/schemas/subscription_create' }

      let(:bills_at) { 'end' }
      let(:permission_group) { create(:permission_group, organization: organization) }
      let!(:subscription) do
        {
          customer_id: customer.id,
          pricing_ids: pricings.map(&:id),
          billing_period_duration: 'P0Y1M0DT0H0M0S',
          trial_finishes_at: 15.days.from_now.iso8601,
          bills_at: bills_at,
          permission_group_id: permission_group.id
        }
      end

      response '201', 'subscription created' do
        schema('$ref' => '#/components/schemas/subscription_resource')
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      it_behaves_like 'unauthorized endpoint'

      context 'when bills at start and has metered logics' do
        let(:bills_at) { 'start' }

        before do
          create(:price_logic_per_unit, pricing: pricings[0])
        end

        it_behaves_like 'unprocessable entity endpoint'
      end
    end
  end

  path '/api/v1/subscriptions/{id}/end_subscription' do
    parameter name: :id, in: :path, schema: { type: :string }
    let(:active) { true }
    let(:existent_subscription) do
      create(:subscription, customer: customer, active: active)
    end
    let(:current_billing_period) do
      create(:billing_period, subscription: existent_subscription)
    end

    before do
      allow(existent_subscription).to receive(
        :current_billing_period
      ).and_return(current_billing_period)
    end

    let(:id) { existent_subscription.id }

    patch 'Ends Subscription' do
      tags 'Subscription'
      description 'Ends a Subscription'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      response '200', 'subscription ended' do
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      it_behaves_like 'not_found endpoint'
      it_behaves_like 'unauthorized endpoint'

      context 'when subscription is already ended' do
        let(:active) { false }

        it_behaves_like 'unprocessable entity endpoint'
      end
    end
  end

  path '/api/v1/subscriptions/{id}/add_pricings' do
    parameter name: :id, in: :path, schema: { type: :string }
    let(:existent_subscription) { create(:subscription, customer: customer, active: true) }
    let(:id) { existent_subscription.id }

    patch 'Add Pricings' do
      tags 'Subscription'
      description 'Add pricings to a Subscription'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]
      parameter name: :pricing_ids, in: :body,
                schema: { '$ref': '#/components/schemas/subscription_edit_pricings' }

      let(:pricing_ids) { { pricing_ids: pricings.map(&:id) } }

      context 'when subscription is active' do
        response '200', 'pricings added' do
          schema('$ref' => '#/components/schemas/subscription_resource')
          let(:Authorization) { "Bearer #{token}" }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['subscription']['pricings'].count).to eq(2)
          end
        end

        context 'when pricings have repeated products' do
          let(:pricing_ids) { { pricing_ids: [pricings[0].id, pricings[0].id] } }

          response '200', 'pricings added' do
            schema('$ref' => '#/components/schemas/subscription_resource')
            let(:Authorization) { "Bearer #{token}" }

            run_test! do |response|
              data = JSON.parse(response.body)
              expect(data['subscription']['pricings'].count).to eq(1)
            end
          end
        end
      end

      context 'when subscription is ended' do
        let(:existent_subscription) { create(:subscription, customer: customer, active: false) }

        it_behaves_like 'unprocessable entity endpoint'
      end

      context 'when subscription already subscribed to product' do
        before do
          create(:pricing_subscription, subscription: existent_subscription, pricing: pricings[0])
        end

        it_behaves_like 'unprocessable entity endpoint'
      end

      context 'when pricings have different currencies' do
        let(:pricing_ids) { { pricing_ids: [pricings[0].id, eur_pricing.id] } }
        let(:eur_pricing) { create(:pricing, product: products[1], currency: 'CLP') }
        let(:existent_subscription) do
          create(:subscription, customer: customer, active: true, currency: 'USD')
        end

        it_behaves_like 'unprocessable entity endpoint'
      end

      it_behaves_like 'not_found endpoint'
      it_behaves_like 'unauthorized endpoint'
    end
  end

  path '/api/v1/subscriptions/{id}/remove_pricings' do
    parameter name: :id, in: :path, schema: { type: :string }
    let(:subscription) { create(:subscription, customer: customer, active: true) }
    let(:id) { subscription.id }

    patch 'Remove Pricings' do
      tags 'Subscription'
      description 'Remove pricings to a Subscription'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]
      parameter name: :pricing_ids, in: :body,
                schema: { '$ref': '#/components/schemas/subscription_edit_pricings' }

      let(:pricing_ids) { { pricing_ids: [pricings[0].id] } }

      context 'when subscription is subscribed to pricing' do
        before do
          create(:pricing_subscription, subscription: subscription, pricing: pricings[0])
          create(:pricing_subscription, subscription: subscription, pricing: pricings[1])
        end

        response '200', 'pricings removed' do
          schema('$ref' => '#/components/schemas/subscription_resource')
          let(:Authorization) { "Bearer #{token}" }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['subscription']['pricings'].count).to eq(1)
          end
        end
      end

      it_behaves_like 'not_found endpoint'
      it_behaves_like 'unauthorized endpoint'
    end
  end
end
