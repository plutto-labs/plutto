class Api::V1::CustomersController < Api::V1::BaseController
  PARAMS = Customer.attribute_names + ['billing_information']
  wrap_parameters include: PARAMS

  def index
    respond_with(paginate(customers))
  end

  def show
    respond_with(customer, deep_serialize: true)
  end

  def create
    customer = Customer.create!(customer_params.merge(organization_id: organization.id))
    respond_with(customer.reload, deep_serialize: true)
  end

  def update
    respond_with(customer.tap { |c| c.update!(customer_params) }, deep_serialize: true)
  end

  def destroy
    respond_with customer.destroy!
  end

  private

  def customer
    @customer ||= policy_scope(Customer).find_by!(
      'id = ? OR identifier = ?', params[:id].to_s, params[:id].to_s
    )
  end

  def customers
    @customers ||= policy_scope(Customer).reverse_order
  end

  def customer_params
    cust_params = params.require(:customer).permit(
      :identifier, :email, :name, billing_information: [
        :country_iso_code, :state, :city, :address, :zip, :activity, :legal_name, :tax_id,
        :phone, :customer_id
      ]
    )
    rename_nested_object_params_for_nested_attributes(cust_params, :billing_information)
  end
end
