class KushkiService < PowerTypes::Service.new(:customer)
  def enroll(params)
    invoice = Invoice.find(params[:invoice_id])
    body = {
      token: params[:token],
      planName: 'Plutto',
      periodicity: 'custom',
      contactDetails: contact_details,
      amount: { subtotalIva: 0, subtotalIva0: 0, ice: 0, iva: 0, currency: invoice.currency },
      startDate: (Date.current + 1.day).to_s
    }
    res = client.post('/subscriptions/v1/card', body)
    if res.code == 201
      create_payment_method(params[:token], res['subscriptionId'], invoice.currency)
      ChangeInvoiceStatusJob.perform_later(invoice, 'charge')
    end
    res
  end

  def charge(payment_method, invoice)
    subscription_id = payment_method.gateway_info['subscription_id']
    body = { amount: charge_amount(invoice),
             contactDetails: contact_details,
             orderDetails: order_details(invoice),
             productDetails: product_details(invoice),
             fullResponse: true }
    res = client.post("/subscriptions/v1/card/#{subscription_id}", body)
    if res.code == 201
      return Payment.create!(
        payment_method: payment_method, invoice: invoice, gateway: 'kushki',
        id_in_gateway: res['ticketNumber'], payment_data: res['details']
      )
    end

    raise PluttoErrors::PaymentError,
          "Kushki Error: #{res.dig('details', 'response_text') || res.dig('message')}"
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

  def enroll_link_for(invoice)
    key = "customer|#{invoice.customer.id}||invoice|#{invoice.id}"
    token = EncryptionService.encrypt(key)
    escaped_token = CGI.escape token
    "https://#{ENV.fetch('APPLICATION_HOST')}/#/checkout?token=#{escaped_token}"
  end

  private

  def create_payment_method(token, subscription_id, currency)
    payment_method = @customer.payment_methods.create!(
      gateway: 'kushki', category: 'credit_card', currency: currency,
      gateway_info: { token: token, subscription_id: subscription_id }
    )
    update_payment_method_data(payment_method)
  end

  def client
    @client ||= KushkiClient.new
  end

  def contact_details
    {
      # documentType: 'CC',
      # documentNumber: customer.billing_information&.tax_id,
      email: @customer.email,
      firstName: @customer.name || @customer.billing_information&.legal_name,
      lastName: 'DeLonghi',
      phoneNumber: @customer.billing_information&.phone
    }
  end

  def charge_amount(invoice)
    {
      ice: 0, iva: 0, subtotalIva: 0,
      subtotalIva0: invoice.total.amount.to_f, currency: invoice.currency
    }
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
