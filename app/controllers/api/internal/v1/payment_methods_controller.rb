class Api::Internal::V1::PaymentMethodsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def create
    res = service.enroll(customer, payment_method_params)
    render json: res, status: res.code
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:gateway, :token)
  end

  def service
    raise 'wrong gateway' unless payment_method_params[:gateway] == 'kushki'

    @service ||= "#{payment_method_params[:gateway].capitalize}Service".constantize.new
  end

  def customer
    policy_scope(Customer).find(params[:customer_id])
  end
end
