class KushkiClient
  include HTTParty
  KUSHKI_PRIVATE_MERCHANT_ID = ENV.fetch('KUSHKI_PRIVATE_MERCHANT_ID')
  base_uri ENV.fetch('KUSHKI_BASE_URL')

  def get(path)
    self.class.get(path, headers: headers)
  end

  def post(path, body, timeout = 28)
    self.class.post(path, headers: headers, body: body.to_json, timeout: timeout)
  end

  private

  def headers
    {
      'Private-Merchant-Id': KUSHKI_PRIVATE_MERCHANT_ID,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
  end
end
