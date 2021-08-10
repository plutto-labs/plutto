require 'rails_helper'

RSpec.describe Plan, type: :model do
  it 'has a valid factory' do
    expect(build(:plan)).to be_valid
  end

  describe 'Relations' do
    it { is_expected.to have_many(:plan_versions) }
    it { is_expected.to belong_to(:organization) }
  end

  it_behaves_like 'token-identifier model' do
    let(:subject) { build(:customer) }
  end
end
