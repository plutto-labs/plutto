class MercadopagoClient
  include HTTParty
  MERCADOPAGO_PRIVATE_KEY = ENV.fetch('MERCADOPAGO_PRIVATE_KEY')
  base_uri 'https://api.mercadopago.com'

  def get(path)
    self.class.get(path, headers: headers)
  end

  def post(path, body, timeout = 28)
    self.class.post(path, headers: headers, body: body.to_json, timeout: timeout)
  end

  private

  def headers
    {
      'Authorization': "Bearer #{MERCADOPAGO_PRIVATE_KEY}",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
  end
end
