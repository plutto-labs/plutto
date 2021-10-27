describe Api::Internal::V1::BaseController, type: :controller do
  controller do
    def index; end
  end

  describe '#callbacks' do
    context 'with user logged in' do
      let(:organization) { create(:organization) }
      let(:user) { create(:user, organization: organization) }

      before do
        sign_in(user)
        allow(Analytics).to receive(:track).with(
          user_id: user.organization.id,
          event: 'internal index base'
        )
      end

      it 'track request using analytics variable' do
        get :index, format: :json
        expect(Analytics).to have_received(:track).with(
          user_id: user.organization.id,
          event: 'internal index base'
        ).once
      end
    end
  end
end
