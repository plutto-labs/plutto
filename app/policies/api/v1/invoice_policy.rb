class Api::V1::InvoicePolicy < Api::V1::ApiPolicy
  def mark_as?
    true
  end

  class Scope < Scope
    def resolve
      scope.joins(:customer).where(customers: { organization_id: organization.id })
    end
  end
end
