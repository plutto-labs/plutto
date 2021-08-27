require 'money-rails/test_helpers'

RSpec.shared_examples 'a metered price logic' do
  describe 'Relations' do
    it { expect(price_logic).to belong_to(:meter) }
  end

  describe '.metered?' do
    it { expect(described_class).to be_metered }
  end
end
