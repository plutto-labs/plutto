class Api::V1::ApiPolicy
  attr_reader :bearer, :record

  def initialize(bearer, record)
    @bearer = bearer
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    true
  end

  def edit?
    update?
  end

  def destroy?
    true
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
