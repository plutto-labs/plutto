# rubocop:disable RSpec/SharedContext, RSpec/VariableName
RSpec.shared_examples 'unprocessable entity endpoint' do
  response '422', 'unprocessable entity' do
    schema('$ref' => '#/components/schemas/unprocessable_entity_error_resource')

    let(:Authorization) { "Bearer #{token}" }
    run_test!
  end
end
# rubocop:enable RSpec/SharedContext, RSpec/VariableName
