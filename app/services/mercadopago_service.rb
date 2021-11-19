class MercadopagoService
  def enroll(customer, params, create_subscription = true)
    permission_group = customer.organization.permission_groups.find(params[:permission_group_id])

    raise 'Need valid permission group' unless permission_group

    token_info = params[:token_info]
    preapproval = client.post(
      '/preapproval', preapproval_body(customer, permission_group, token_info[:id])
    )
    raise 'Mercadopago error' unless preapproval.code == 201

    create_payment_method(token_info, preapproval, customer, permission_group.price_currency)
    create_subscription(customer, permission_group) if create_subscription
  end

  private

  def preapproval_body(customer, permission_group, token)
    {
      auto_recurring: {
        currency_id: 'CLP' || permission_group.price_currency,
        transaction_amount: permission_group.price.amount,
        frequency: 1,
        frequency_type: 'months'
      },
      back_url: "https://www.mercadopago.cl/",
      collector_id: 1006161850,
      payer_email: customer.email,
      reason: "Plan #{permission_group.name} - #{customer.organization.name}",
      card_token_id: token,
      status: 'authorized',
      external_reference: customer.id
    }
  end

  def create_subscription(customer, permission_group)
    CreateSubscription.for(
      customer: customer,
      permission_group_id: permission_group.id,
      billing_period_duration: 'P1M',
      bills_at: 'start'
    )
  end

  def create_payment_method(token_info, subscription_info, customer, currency)
    customer.payment_methods.create!(
      gateway: 'mercadopago', category: 'credit_card', currency: currency,
      gateway_info: {
        token: token_info[:id],
        subscription_id: subscription_info['id'],
        payer_id: subscription_info['payer_id'],
        card_id: subscription_info['card_id'],
        auto_recurring: subscription_info['auto_recurring']
      },
      last_4_digits: token_info.dig('last_four_digits'),
      card_brand: subscription_info.dig('payment_method_id')&.downcase
    )
  end

  def client
    @client ||= MercadopagoClient.new
  end
end
