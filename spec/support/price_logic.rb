require 'money-rails/test_helpers'

RSpec.shared_examples 'a price logic' do
  describe 'Validations' do
    it { expect(price_logic).to validate_presence_of(:type) }
    it { expect(price_logic).to validate_presence_of(:meter_count_method) }
  end

  it { expect(price_logic).to monetize(:price_cents) }
end
