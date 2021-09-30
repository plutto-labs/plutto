require 'swagger_helper'

describe 'API V1 Subscription', swagger_doc: 'v1/swagger.json' do
  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, organization: organization) }
  let(:product) { create(:product, organization: organization) }
  let!(:pricing)  { create(:pricing, product: product) }
  let(:api_key) { create(:api_key, bearer: organization) }
  let!(:token) { api_key.token }

  path '/subscriptions' do
    post 'Creates Subscription' do
      tags 'Subscription'
      description "Creates Subscription for one or more products \n\n"\
       "Make sure pricing_ids is NOT NULL."
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]
      parameter name: :subscription, in: :body,
                schema: { '$ref': '#/definitions/subscription_create' }

      context 'with pricing_ids' do
        let(:subscription) do
          {
            subscription: {
              customer_id: customer.id,
              pricing_ids: [pricing.id],
              billing_period_duration: 'P0Y1M0DT0H0M0S',
              trial_finishes_at: 15.days.from_now.iso8601
            }
          }
        end

        response '201', 'subscription created' do
          schema('$ref' => '#/definitions/subscription_resource')
          let(:Authorization) { "Bearer #{token}" }

          run_test!
        end

        it_behaves_like 'unauthorized endpoint'
      end
    end
  end

  path '/subscriptions/{id}/end_subscription' do
    parameter name: :id, in: :path, type: :string
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
end
