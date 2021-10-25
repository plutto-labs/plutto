describe Api::Internal::V1::BaseController, type: :controller do
  controller do
    def index; end
  end

  describe '#callbacks' do
    context 'with user logged in' do
      let(:user) { create(:user) }

      before do
        sign_in(user)
        allow(Analytics).to receive(:track).with(
          user_id: user.id,
          event: 'internal index base'
        )
      end

      it 'track request using analytics variable' do
        get :index, format: :json
        expect(Analytics).to have_received(:track)
      end
    end
  end
end
