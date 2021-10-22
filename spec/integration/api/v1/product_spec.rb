require 'swagger_helper'

describe 'API V1 Products', swagger_doc: 'v1/swagger.json' do
  let(:organization) { create(:organization) }
  let(:api_key) { create(:api_key, bearer: organization) }
  let!(:token) { api_key.token }

  path '/api/v1/products' do
    get 'Retrieves Products' do
      tags 'Products'
      description 'Retrieves all the Products'
      produces 'application/json'
      security [Bearer: []]

      let(:collection_count) { 5 }
      let(:expected_collection_count) { collection_count }

      before do
        create_list(
          :product,
          collection_count,
          organization: organization
        )
      end

      response '200', 'Products retrieved' do
        schema('$ref' => '#/components/schemas/products_collection')
        let(:Authorization) { "Bearer #{token}" }

        run_test! do |response|
          expect(JSON.parse(response.body)['products'].count).to eq(
            expected_collection_count
          )
        end
      end

      it_behaves_like 'unauthorized endpoint'
    end
  end
end
