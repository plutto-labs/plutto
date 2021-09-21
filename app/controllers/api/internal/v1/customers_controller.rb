class Api::Internal::V1::CustomersController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(
      authorize(
        Customer.where(organization_id: current_user.organization_id)
          .includes([:billing_information, { active_plan_subscription: :plan_version }])
      )
    )
  end

  def active
    respond_with(
      authorize(
        Customer.where(organization_id: current_user.organization_id).active
          .includes([:billing_information, { active_plan_subscription: :plan_version }])
      ),  active: true
    )
  end

  def show
    authorize customer
    respond_with(customer, active: true, current_period_details: true)
  end

  def create
    customer = authorize(
      Customer.create!(customer_params.merge(organization_id: current_user.organization_id))
    )
    ActiveRecord::Base.transaction do
      if plan_version_params['plan_version_id']&.present? && plan_version
        customer.add_plan_subscription(plan_version)
      end
      customer.save!
    end

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
      'id = ? OR identifier = ?', params[:id], params[:id]
    )
  end

  def plan_version_params
    params.require(:customer).permit(:plan_version_id)
  end

  def plan_version
    @plan_version ||= policy_scope(PlanVersion).find(plan_version_params[:plan_version_id])
  end
end
