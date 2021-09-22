class KushkiService
  def enroll(customer, params)
    body = {
      token: params[:token],
      planName: 'Plutto',
      periodicity: 'custom',
      contactDetails: contact_deatils(customer),
      amount: { subtotalIva: 0, subtotalIva0: 0, ice: 0, iva: 0, currency: 'CLP' },
      startDate: (Date.current + 1.day).to_s
    }
    response = client.post('/subscriptions/v1/card', body)
    if response.code == 201
      create_payment_method(params[:token], response['subscriptionId'], customer)
    end
    response
  end

  private

  def create_payment_method(token, subscription_id, customer)
    customer.payment_methods.create!(
      gateway: 'kushki', category: 'credit_card',
      gateway_info: { token: token, subscription_id: subscription_id }
    )
  end

  def client
    @client ||= KushkiClient.new
  end

  def contact_deatils(customer)
    {
      # documentType: 'CC',
      # documentNumber: customer.billing_information&.tax_id,
      email: customer.email,
      firstName: customer.name || customer.billing_information&.legal_name,
      lastName: 'DeLonghi',
      phoneNumber: customer.billing_information&.phone
    }
  end
end
