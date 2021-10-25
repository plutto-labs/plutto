require 'swagger_helper'

describe 'API V1 Permission Groups', swagger_doc: 'v1/swagger.json' do
  let(:organization) { create(:organization) }
  let(:api_key) { create(:api_key, bearer: organization) }
  let!(:token) { api_key.token }

  path '/api/v1/permission_groups' do
    get 'Retrieves Permission Groups' do
      tags 'Permission Groups'
      description 'Retrieves all the Permission Groups'
      produces 'application/json'
      security [Bearer: []]

      let(:collection_count) { 5 }
      let(:expected_collection_count) { collection_count }

      before do
        create_list(
          :permission_group,
          collection_count,
          organization: organization
        )
      end

      response '200', 'Permission Groups retrieved' do
        schema('$ref' => '#/components/schemas/permission_groups_collection')
        let(:Authorization) { "Bearer #{token}" }

        run_test! do |response|
          expect(JSON.parse(response.body)['permission_groups'].count).to eq(
            expected_collection_count
          )
        end
      end

      it_behaves_like 'unauthorized endpoint'
    end
  end
end
