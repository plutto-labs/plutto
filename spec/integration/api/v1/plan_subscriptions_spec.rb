require 'swagger_helper'

describe 'API V1 Plan Subscription', swagger_doc: 'v1/swagger.json' do
  let(:organization) { create(:organization) }
  let(:customer) { create(:customer, organization: organization) }
  let(:plan) { create(:plan, organization: organization) }
  let(:plan_version)  { create(:plan_version, plan: plan) }
  let(:api_key) { create(:api_key, bearer: organization) }
  let!(:token) { api_key.token }

  path '/plan_subscriptions' do
    post 'Creates Plan Subscription' do
      tags 'Plan Subscription'
      description "Creates Plan Subscription with plan version ID or plan ID \n\n"\
       "Make sure plan_version_id or plan_id is NOT NULL. If both arguments are present, "\
       "plan_version_id will be utilized"
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]
      parameter name: :plan_subscription, in: :body,
                schema: { '$ref': '#/definitions/plan_subscription_create' }

      before do # rubocop:disable RSpec/ScatteredSetup
        plan.update(default_version: plan_version)
      end

      context 'with plan_version_id' do
        let(:plan_subscription) do
          {
            plan_subscription: {
              customer_id: customer.id,
              plan_version_id: plan_version.id
            }
          }
        end

        response '201', 'plan_subscription created' do
          schema('$ref' => '#/definitions/plan_subscription_resource')
          let(:Authorization) { "Bearer #{token}" }

          run_test!
        end

        it_behaves_like 'unauthorized endpoint'
      end

      context 'with plan_id' do
        let(:plan_subscription) do
          {
            plan_subscription: {
              customer_id: customer.id,
              plan_id: plan.id
            }
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
  end

  path '/plan_subscriptions/{id}/end_subscription' do
    parameter name: :id, in: :path, type: :string
    let(:active) { true }
    let(:existent_plan_subscription) do
      create(:plan_subscription, customer: customer, plan_version: plan_version, active: active)
    end
    let(:current_billing_period) do
      create(:billing_period, plan_subscription: existent_plan_subscription)
    end

    before do # rubocop:disable RSpec/ScatteredSetup
      allow(existent_plan_subscription).to receive(
        :current_billing_period
      ).and_return(current_billing_period)
    end

    let(:id) { existent_plan_subscription.id }

    patch 'Ends Plan Subscription' do
      tags 'Plan Subscription'
      description 'Ends a Plan Subscription'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      response '200', 'plan subscription ended' do
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      it_behaves_like 'not_found endpoint'
      it_behaves_like 'unauthorized endpoint'

      context 'when plan subscription is already ended' do
        let(:active) { false }

        it_behaves_like 'unprocessable entity endpoint'
      end
    end
  end
end
