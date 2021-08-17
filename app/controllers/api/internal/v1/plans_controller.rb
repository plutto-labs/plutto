class Api::Internal::V1::PlansController < Api::Internal::V1::BaseController
  acts_as_token_authentication_handler_for User
  include Pundit

  def index
    respond_with(authorize(Plan.where(organization_id: current_user.organization_id)))
  end

  def show
    authorize plan
    respond_with(plan)
  end

  def create
    plan = nil

    ActiveRecord::Base.transaction do
      plan = authorize(
        Plan.new(plan_params.merge(organization_id: current_user.organization_id))
      )
      plan.add_plan_version(plan_version_params)
      plan.save!
    end
    respond_with(plan)
  end

  def update
    authorize plan
    plan.update!(plan_params)
    respond_with(plan)
  end

  def destroy
    authorize plan
    respond_with(plan.destroy!)
  end

  private

  def plan_params
    params.require(:plan).permit(
      :name
    )
  end

  def plan_version_params
    params.require(:plan_version).permit
  end

  def plan
    @plan ||= Plan.find(params[:id])
  end
end
