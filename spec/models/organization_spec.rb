require 'rails_helper'

RSpec.describe Organization, type: :model do
  it 'has a valid factory' do
    expect(build(:organization)).to be_valid
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'Relations' do
    it { is_expected.to have_many(:users) }
  end
end
