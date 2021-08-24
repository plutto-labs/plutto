# rubocop:disable RSpec/SharedContext, RSpec/VariableName
RSpec.shared_examples 'unauthorized endpoint' do
  response '401', 'authentication failed', document: false do
    let(:Authorization) { 'Bearer invalid_token' }
    run_test!
  end
end
# rubocop:enable RSpec/SharedContext, RSpec/VariableName
