class CustomerPolicy < ApplicationPolicy
  def initialize(current_user, record)
    @user = current_user
    @record = record
  end

  def index?
    true
  end

  def show?
    from_company?
  end

  def create?
    true
  end

  def update?
    from_company?
  end

  def destroy?
    update?
  end

  private

  def from_company?
    @user.organization_id == @record.organization_id
  end
end
