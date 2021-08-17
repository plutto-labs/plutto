class OrganizationRelatedPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    from_company?
  end

  def create?
    from_company?
  end

  def update?
    from_company?
  end

  def destroy?
    update?
  end

  private

  def from_company?
    @user.organization_id == organization_id
  end

  def organization_id
    raise NotImplementedError
  end
end
