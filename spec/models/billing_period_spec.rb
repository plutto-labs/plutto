require 'rails_helper'

RSpec.describe BillingPeriod, type: :model do
  it 'has a valid factory' do
    expect(build(:billing_period)).to be_valid
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:plan_subscription) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:billing_period) }
  end
end
