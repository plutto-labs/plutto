class CustomerPolicy < OrganizationRelatedPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def active?
    index?
  end

  def trial?
    index?
  end

  def show?
    true
  end

  def update?
    true
  end

  def destroy?
    from_company?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      organization_id ? scope.where(organization_id: organization_id) : scope.all
    end

    def organization_id
      @organization_id ||= @user&.organization_id
    end
  end

  private

  def organization_id
    @record&.organization_id
  end
end
