class Api::V1::InvoicesController < Api::V1::BaseController
  def index
    respond_with(paginate(policy_scope(Invoice).includes(:customer)))
  end

  def show
    respond_with invoice
  end

  private

  def invoice
    @invoice ||= policy_scope(Invoice).find_by!(id: params[:id])
  end
end
