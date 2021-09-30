require 'money-rails/test_helpers'

RSpec.shared_examples 'a metered price logic' do
  describe '.metered?' do
    it { expect(price_logic.metered?).to be(true) }
  end
end
