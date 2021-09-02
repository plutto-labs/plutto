require 'swagger_helper'

describe 'API V1 Meter Events', swagger_doc: 'v1/swagger.json' do
  let(:organization) { create(:organization) }
  let!(:customer) { create(:customer, organization: organization) }
  let(:meter) { create(:meter, organization: organization) }
  let(:api_key) { create(:api_key, bearer: organization) }
  let!(:token) { api_key.token }

  path '/meter_events' do
    post 'Creates Meter Event' do
      description 'Creates Meter Event'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :meter_event, in: :body,
                schema: { '$ref': '#/definitions/meter_event_create' }

      let(:meter_event) do
        {
          timestamp: '1984-06-04 09:00',
          amount: 10,
          action: 'increment',
          customer_id: customer.id,
          meter_id: meter.id
        }
      end

      response '201', 'meter_event created' do
        schema('$ref' => '#/definitions/meter_event_resource')
        let(:Authorization) { "Bearer #{token}" }

        run_test!
      end

      it_behaves_like 'unauthorized endpoint'
    end
  end
end
