class Api::Internal::V1::PaymentMethodsController < Api::Internal::V1::BaseController
  ALLOWED_GATEWAYS = %w(kushki mercadopago).freeze

  def create
    res = service.enroll(customer, payment_method_params)
    render json: res, status: res.code
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(
      :gateway, :token, :invoice_id, :permission_group_id, token_info: {}
    )
  end

  def service
    raise 'wrong gateway' unless ALLOWED_GATEWAYS.include?(payment_method_params[:gateway])

    @service ||= "#{payment_method_params[:gateway].capitalize}Service".constantize.new
  end

  def customer
    Customer.find(params[:customer_id])
  end
end
