# rubocop:disable RSpec/SharedContext, RSpec/VariableName
RSpec.shared_examples 'not_found endpoint' do
  response '404', 'resource not found' do
    schema('$ref' => '#/components/schemas/not_found_error_resource')

    let(:Authorization) { "Bearer #{token}" }
    let(:id) { 'invalid_id-1234' }
    run_test!
  end
end
# rubocop:enable RSpec/SharedContext, RSpec/VariableName
