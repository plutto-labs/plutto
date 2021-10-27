class Api::Internal::V1::CustomersController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(customers.send(params[:filter])), params[:filter].to_sym => true)
  end

  def show
    authorize customer
    respond_with(customer, active: true, current_period_details: true, show: true)
  end

  def create
    customer = authorize(
      Customer.create!(customer_params.merge(organization_id: current_user.organization_id))
    )

    respond_with(customer.reload)
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
    cust_params = params.require(:customer).permit(
      :identifier, :email, :name, billing_information: [
        :country_iso_code, :state, :city, :address, :zip, :activity, :legal_name, :tax_id, :phone
      ]
    )
    rename_nested_object_params_for_nested_attributes(cust_params, :billing_information)
  end

  def customer
    @customer ||= policy_scope(Customer).find_by!(
      'id = ? OR identifier = ?', params[:id].to_s, params[:id].to_s
    )
  end

  def customers
    @customers ||= policy_scope(Customer).reverse_order
  end
end
