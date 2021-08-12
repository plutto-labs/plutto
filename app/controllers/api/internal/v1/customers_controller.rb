class Api::Internal::V1::CustomersController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(Customer.where(organization_id: current_user.organization_id)))
  end

  def show
    authorize customer
    respond_with(customer)
  end

  def create
    customer = authorize(
      Customer.create!(customer_params.merge(organization_id: current_user.organization_id))
    )
    respond_with(customer)
  end

  def update
    authorize customer
    customer.update!(customer_params)
    respond_with(customer)
  end

  def destroy
    authorize customer
    respond_with(customer.destroy!)
  end

  private

  def customer_params
    params.require(:customer).permit(
      :email, :name
    )
  end

  def customer
    @customer ||= Customer.find(params[:id])
  end
end
