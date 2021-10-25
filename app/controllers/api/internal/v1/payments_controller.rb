class Api::Internal::V1::PaymentsController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(filtered_collection(authorize(payments)))
  end

  def show
    respond_with(authorize(payment), show: true)
  end

  private

  def payment
    @payment ||= policy_scope(Payment).find_by!(id: params[:id])
  end

  def payments
    policy_scope(Payment).reverse_order.includes(:invoice, :payment_method)
  end
end
