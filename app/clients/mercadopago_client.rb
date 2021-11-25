class MercadopagoClient
  include HTTParty
  base_uri 'https://api.mercadopago.com'

  def initialize(access_token)
    raise PluttoErrors::PaymentError, 'Mercadopago key is required' if access_token.nil?

    @access_token = access_token
  end

  def get(path)
    self.class.get(path, headers: headers)
  end

  def post(path, body, timeout = 28)
    self.class.post(path, headers: headers, body: body.to_json, timeout: timeout)
  end

  private

  def headers
    {
      'Authorization': "Bearer #{@access_token}",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
  end
end
