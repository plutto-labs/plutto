class Api::Internal::V1::PaymentMethodsController < Api::Internal::V1::BaseController
  def create
    res = service.enroll(customer, payment_method_params)
    render json: res, status: res.code
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:gateway, :token, :invoice_id)
  end

  def service
    raise 'wrong gateway' unless payment_method_params[:gateway] == 'kushki'

    @service ||= "#{payment_method_params[:gateway].capitalize}Service".constantize.new
  end

  def customer
    Customer.find(params[:customer_id])
  end
end
