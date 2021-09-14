class Api::V1::InvoicePolicy < Api::V1::ApiPolicy
  class Scope < Scope
    def resolve
      scope.joins(:customer).where(customers: { organization_id: organization.id })
    end
  end
end
