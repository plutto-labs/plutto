class Api::Internal::V1::CustomersController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(
      authorize(
        Customer.where(organization_id: current_user.organization_id)
          .includes([:active_plan_subscription])
      )
    )
  end

  def show
    authorize customer
    respond_with(customer)
  end

  def create
    customer = authorize(
      Customer.new(customer_params.merge(organization_id: current_user.organization_id))
    )
    ActiveRecord::Base.transaction do
      if plan_version_params['plan_version_id']
        customer.add_plan_subcription(plan_version_params['plan_version_id'])
      end
      customer.save!
    end
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

  def plan_version_params
    params.require(:customer).permit(:plan_version_id)
  end
end
