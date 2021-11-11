# rubocop:disable RSpec/SharedContext, RSpec/VariableName
RSpec.shared_examples 'only secret api key endpoint' do
  response '401', 'authentication failed' do
    schema('$ref' => '#/components/schemas/unauthorized_error_resource')
    let!(:api_key) { create(:api_key, bearer: organization, category: 'pk') }
    let(:Authorization) { "Bearer #{api_key.token}" }
    run_test!
  end
end
# rubocop:enable RSpec/SharedContext, RSpec/VariableName
