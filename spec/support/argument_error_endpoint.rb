# rubocop:disable RSpec/SharedContext, RSpec/VariableName
RSpec.shared_examples 'argument error endpoint' do
  response '400', 'bad request' do
    schema('$ref' => '#/definitions/argument_error_resource')
    let(:Authorization) { "Bearer #{token}" }

    run_test!
  end
end
# rubocop:enable RSpec/SharedContext, RSpec/VariableName
