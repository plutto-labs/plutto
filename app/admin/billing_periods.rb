ActiveAdmin.register BillingPeriod do
  belongs_to :plan_subscription

  show do
    attributes_table do
      row :id
      row :plan_subscription
      row :to
      row :from
      row :created_at
      row :updated_at
    end

    panel I18n.t('activerecord.models.meter_count', count: 2) do
      table_for resource.meter_counts do
        column(:id) do |meter_count|
          link_to(meter_count.id,
                  admin_organization_meter_counts_path(organization_id: resource.id,
                                                       meter_count_id: meter_count.id))
        end
        column :meter
        column :count
        column :updated_at
      end
    end
  end
end
