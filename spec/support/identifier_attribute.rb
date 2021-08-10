RSpec.shared_examples 'token-identifier model' do
  describe 'generates an identifier token' do
    it { expect(subject.identifier).not_to be_empty }
    it { expect(subject).to validate_uniqueness_of(:identifier) }
  end
end
