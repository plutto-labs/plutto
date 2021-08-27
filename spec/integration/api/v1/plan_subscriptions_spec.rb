require 'swagger_helper'

describe 'API V1 Plan Subscription', swagger_doc: 'v1/swagger.json' do
  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, organization: organization) }
  let(:plan_version)  { create(:plan_version, plan: create(:plan, organization: organization)) }
  let(:api_key) { create(:api_key, bearer: organization) }
  let!(:token) { api_key.token }

  path '/plan_subscriptions' do
    post 'Creates Plan Subscription' do
      tags 'Plan Subscription'
      description 'Creates Plan Subscription'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :plan_subscription, in: :body, schema: {
        type: :object,
        properties:
        {
          customer_id: { type: :string, example: 'customer_5198c6ad60c3363b089a1421',
                         'x-nullable': false },
          plan_version_id: { type: :string, example: 'version_5198c6ad60c3363b089a1421',
                             'x-nullable': false }
        }
      }

      let(:plan_subscription) do
        {
          customer_id: customer.identifier,
          plan_version_id: plan_version.identifier
        }
      end

      response '201', 'plan_subscription created' do
        schema('$ref' => '#/definitions/plan_subscription_resource')
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      it_behaves_like 'unauthorized endpoint'
    end
  end

  path '/plan_subscriptions/{id}' do
    parameter name: :id, in: :path, type: :string

    let(:existent_plan_subscription) do
      create(:plan_subscription, customer: customer, plan_version: plan_version)
    end

    let(:id) { existent_plan_subscription.identifier }

    patch 'Updates Plan Subscription' do
      tags 'Plan Subscription'
      description 'Updates Plan Subscription status'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :plan_subscription, in: :body, schema: {
        type: :object,
        properties: {
          active: { type: :boolean, example: true, 'x-nullable': false }
        }
      }

      let(:plan_subscription) { { active: 'false' } }

      response '200', 'plan subscription updated' do
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      it_behaves_like 'unauthorized endpoint'
    end
  end
end