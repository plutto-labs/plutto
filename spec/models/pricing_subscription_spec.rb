require 'rails_helper'

RSpec.describe PricingSubscription, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:pricing) }
    it { is_expected.to belong_to(:subscription) }
  end
end
