class Api::V1::ApiPolicy
  attr_reader :bearer, :record

  def initialize(bearer, record)
    @bearer = bearer
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :bearer, :scope

    def initialize(bearer, scope)
      @bearer = bearer
      @scope = scope
    end

    def resolve
      scope.where(organization_id: organization.id)
    end

    def organization
      @organization ||= bearer if bearer.is_a?(Organization)
    end
  end
end
