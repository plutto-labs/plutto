class InvoicePolicy < OrganizationRelatedPolicy
  private

  def organization_id
    @record.customer.organization_id
  end
end
