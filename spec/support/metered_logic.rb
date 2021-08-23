require 'money-rails/test_helpers'

RSpec.shared_examples 'a metered price logic' do
  describe 'Relations' do
    it { is_expected.to belong_to(:meter) }
  end

  describe '.metered?' do
    it { expect(described_class).to be_metered }
  end
end
