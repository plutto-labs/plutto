ActiveAdmin.register MeterCount do
  belongs_to :billing_period, optional: true
  includes :customer, :meter, meter: :organization

  show do
    attributes_table do
      row :id
      row :billing_period
      row :meter
      row :count
      row :updated_at
      row :created_at
    end

    panel I18n.t('activerecord.models.meter_event', count: 2) do
      table_for resource.meter_events do
        column(:id) do |meter_event|
          link_to(meter_event.id,
                  admin_organization_meter_events_path(organization_id: resource.id,
                                                       meter_event_id: meter_event.id))
        end
        column :name
        column :customer
        column :amount
        column :action
        column :created_at
      end
    end
  end
end
