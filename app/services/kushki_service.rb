class KushkiService
  def enroll(customer, params)
    body = {
      token: params[:token],
      planName: 'Plutto',
      periodicity: 'custom',
      contactDetails: contact_details(customer),
      amount: { subtotalIva: 0, subtotalIva0: 0, ice: 0, iva: 0, currency: 'CLP' },
      startDate: (Date.current + 1.day).to_s
    }
    res = client.post('/subscriptions/v1/card', body)
    if res.code == 201
      create_payment_method(params[:token], res['subscriptionId'], customer)
    end
    res
  end

  def charge(payment_method, invoice)
    subscription_id = payment_method.gateway_info['subscription_id']
    body = { amount: charge_amount(invoice),
             contactDetails: contact_details(payment_method.customer),
             orderDetails: order_details(invoice),
             productDetails: product_details(invoice),
             fullResponse: true }
    client.post("/subscriptions/v1/card/#{subscription_id}", body)
    # TODO: save payment information
  end

  def update_payment_method_data(payment_method)
    res = client.get(
      "/subscriptions/v1/card/search/#{payment_method.gateway_info['subscription_id']}"
    )
    if res.code == 200
      payment_method.update(
        last_4_digits: res['lastFourDigits'],
        card_brand: res['paymentBrand'].downcase,
        currency: res['amount']['currency']
      )
    end
  end

  def enroll_link_for(customer)
    "https://#{ENV.fetch('APPLICATION_HOST')}/#/add-credit-card?customerId=#{customer.id}"
  end

  private

  def create_payment_method(token, subscription_id, customer)
    payment_method = customer.payment_methods.create!(
      gateway: 'kushki', category: 'credit_card',
      gateway_info: { token: token, subscription_id: subscription_id }
    )
    update_payment_method_data(payment_method)
  end

  def client
    @client ||= KushkiClient.new
  end

  def contact_details(customer)
    {
      # documentType: 'CC',
      # documentNumber: customer.billing_information&.tax_id,
      email: customer.email,
      firstName: customer.name || customer.billing_information&.legal_name,
      lastName: 'DeLonghi',
      phoneNumber: customer.billing_information&.phone
    }
  end

  def charge_amount(invoice)
    { ice: 0, iva: 0, subtotalIva: 0, subtotalIva0: invoice.total.amount.to_f, currency: 'USD' }
  end

  def product_details(invoice)
    {
      product: invoice.details.map do |p|
        { id: p['id'], title: p['description'], price: p['total_price'], quantity: 1 }
      end
    }
  end

  def order_details(invoice)
    billing_information = invoice.billing_information
    {
      siteDomain: 'getplutto.com',
      billingDetails: {
        name: billing_information['legal_name'],
        phone: billing_information['phone'],
        address: billing_information['address'],
        city: billing_information['city'],
        region: billing_information['state'],
        country: billing_information['country_iso_code'],
        zipCode: billing_information['zip']
      }
    }
  end
end
