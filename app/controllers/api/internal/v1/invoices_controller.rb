class Api::Internal::V1::InvoicesController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(filtered_collection(authorize(invoices)))
  end

  def show
    respond_with(authorize(invoice), show: true)
  end

  def change_status
    authorize(invoice)
    invoice.change_status!(event_param)
    respond_with(invoice, show: true)
  end

  private

  def invoice
    @invoice ||= policy_scope(Invoice).find_by!(id: params[:id])
  end

  def invoices
    policy_scope(Invoice).reverse_order.includes(:customer)
  end

  def event_param
    params.require(:event)
  end
end
