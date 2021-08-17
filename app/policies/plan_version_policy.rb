class PlanVersionPolicy < ApplicationPolicy
  def initialize(current_user, record)
    @user = current_user
    @record = record
  end

  def create?
    plan_from_company?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  private

  def plan_from_company?
    @user.organization_id == @record.plan.organization_id
  end
end
