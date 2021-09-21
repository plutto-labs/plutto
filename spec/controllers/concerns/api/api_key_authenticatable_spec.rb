describe Api::ApiKeyAuthenticatable do
  let(:controller_class) do
    Class.new(Api::BaseController) do
      include Api::ApiKeyAuthenticatable

      def respond_with_unauthorized(*_); end
    end
  end

  let(:controller) { controller_class.new }
  let(:api_key) { create(:api_key) }
  let(:authorzation) { 'Bearer sk_123' }
  let(:headers) { { 'Authorization': authorzation } }

  describe '#authenticate_with_api_key!' do
    before do
      allow(controller).to receive(:request).and_return instance_double(
        'ActionDispatch::Request', authorization: authorzation
      )
    end

    context 'when api_key is valid' do
      before do
        allow(ApiKey).to receive(:find_by!).and_return(api_key)
      end

      it 'returns api_key' do
        expect(controller.authenticate_with_api_key!).to eq(api_key.bearer)
      end
    end

    context 'when api_key is invalid' do
      before do
        allow(controller).to receive(:respond_with_unauthorized).and_return nil
      end

      it 'respond with unauthorized api error' do
        controller.authenticate_with_api_key!

        expect(controller).to have_received(:respond_with_unauthorized)
      end
    end

    context 'when authorization is not present' do
      let(:authorzation) { nil }

      before do
        allow(controller).to receive(:respond_with_unauthorized).and_return nil
      end

      it 'respond with unauthorized api error' do
        controller.authenticate_with_api_key!

        expect(controller).to have_received(:respond_with_unauthorized)
      end
    end
  end
end
