class Api::V1::CustomersController < Api::V1::BaseController
  def index
    respond_with(policy_scope(Customer))
  end

  def show
    respond_with(customer)
  end

  def create
    respond_with(Customer.create!(customer_params.merge(organization_id: organization.id)))
  end

  def update
    respond_with(customer.tap { |c| c.update!(customer_params) })
  end

  def destroy
    respond_with customer.destroy!
  end

  private

  def customer
    @customer ||= policy_scope(Customer).find_by!(
      'id = ? OR identifier = ?', params[:id], params[:id]
    )
  end

  def customer_params
    params.require(:customer).permit(:email, :name, :identifier)
  end
end
