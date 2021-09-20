class Api::V1::CustomersController < Api::V1::BaseController
  def index
    respond_with(policy_scope(Customer))
  end

  def show
    respond_with(customer, deep_serialize: true)
  end

  def create
    customer = Customer.create!(customer_params.merge(organization_id: organization.id))
    ActiveRecord::Base.transaction do
      if plan_version_params['plan_version_id']&.present? && plan_version
        customer.add_plan_subscription(plan_version)
      end
      customer.save!
    end

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
      'id = ? OR identifier = ?', params[:id], params[:id]
    )
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

  def plan_version_params
    params.require(:customer).permit(:plan_version_id)
  end

  def plan_version
    @plan_version ||= policy_scope(PlanVersion).find(plan_version_params[:plan_version_id])
  end
end
