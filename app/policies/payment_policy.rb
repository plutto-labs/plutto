class PaymentPolicy < OrganizationRelatedPolicy
  class Scope < Scope
    def resolve
      scope.joins(invoice: :customer).where(customers: { organization_id: organization_id })
    end
  end

  private

  def organization_id
    @record.customer.organization_id
  end
end
