class InvoicePolicy < OrganizationRelatedPolicy
  def change_status?
    from_company?
  end

  class Scope < Scope
    def resolve
      scope.joins(:customer).where(customers: { organization_id: organization_id })
    end
  end

  private

  def organization_id
    @record.customer.organization_id
  end
end
