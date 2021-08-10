require 'rails_helper'

RSpec.describe Customer, type: :model do
  it 'has a valid factory' do
    expect(build(:customer)).to be_valid
  end

  describe 'Relations' do
    it { is_expected.to have_one(:plan_subscription) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:customer) }
  end
end
