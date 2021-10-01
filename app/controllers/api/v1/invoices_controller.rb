class Api::V1::InvoicesController < Api::V1::BaseController
  def index
    respond_with(paginate(filtered_collection(invoices)))
  end

  def show
    respond_with invoice
  end

  private

  def invoice
    @invoice ||= policy_scope(Invoice).find_by!(id: params[:id])
  end

  def invoices
    @invoices ||= policy_scope(Invoice).reverse_order.includes(:customer)
  end
end
