RSpec.describe AdminController, type: :controller do
  describe 'GET #show' do
    let!(:user) { create(:user) }
    let!(:admin) { create(:admin_user) }
    let(:user_id) { user.id }

    def login_as
      get :login_as, params: { id: user_id }
    end

    context 'with logged admin' do
      before do
        sign_in admin
      end

      context 'with valid user id' do
        let(:user_id) { user.id }

        it 'redirects to admin app path' do
          expect(login_as).to redirect_to(admin_app_path)
        end
      end

      context 'with invalid user id' do
        let(:user_id) { 'invalid' }

        it 'raises error' do
          expect { login_as }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'without logged admin' do
      it 'raises error' do
        expect { login_as }.to raise_error(StandardError)
      end
    end
  end
end
