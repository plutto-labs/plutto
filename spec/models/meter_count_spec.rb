require 'rails_helper'

RSpec.describe MeterCount, type: :model do
  it 'has a valid factory' do
    expect(build(:meter_count)).to be_valid
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:billing_period) }
    it { is_expected.to belong_to(:meter) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:meter_count) }
  end
end
