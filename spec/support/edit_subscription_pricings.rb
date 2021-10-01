require 'money-rails/test_helpers'

RSpec.shared_examples 'edit subscription command' do
  context 'when no pricings are given' do
    it 'does not add any pricings' do
      expect { perform([]) }.not_to (change { subscription.pricings.count })
    end
  end

  context 'when subscription is inactive' do
    let(:subscription) { create(:subscription, active: false) }

    it 'raises an error' do
      expect { perform(pricings) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
