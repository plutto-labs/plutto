require 'money-rails/test_helpers'

RSpec.shared_examples 'a price logic' do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:type) }
  end

  it { is_expected.to monetize(:price_cents) }
end
