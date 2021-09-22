class Api::Internal::V1::InvoicesController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(filtered_collection(authorize(invoices)))
  end

  def show
    respond_with(authorize(invoice))
  end

  private

  def invoice
    @invoice ||= policy_scope(Invoice).find_by!(id: params[:id])
  end

  def invoices
    policy_scope(Invoice).includes(:customer)
  end
end
