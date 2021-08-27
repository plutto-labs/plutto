# rubocop:disable RSpec/SharedContext, RSpec/VariableName
RSpec.shared_examples 'unauthorized endpoint' do
  response '401', 'authentication failed' do
    parameter name: :error, in: :body,
              schema: schema('$ref' => '#/definitions/unauthorized_error_resource')

    let(:Authorization) { 'Bearer invalid_token' }
    run_test!
  end
end
# rubocop:enable RSpec/SharedContext, RSpec/VariableName
