require 'rails_helper'

RSpec.describe BillingInformation, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:customer) }
  end
end
