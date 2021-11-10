class Api::V1::ApiPolicy
  attr_reader :api_key, :record

  def initialize(api_key, record)
    @api_key = api_key
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

  def secret_key?
    @api_key.sk?
  end

  class Scope
    attr_reader :api_key, :scope

    def initialize(api_key, scope)
      @bearer = api_key.bearer
      @api_key = api_key
      @scope = scope.ordered
    end

    def resolve
      scope.where(organization_id: organization.id)
    end

    def organization
      @organization ||= api_key.bearer if api_key.bearer.is_a?(Organization)
    end
  end
end
