ActiveAdmin.register BillingPeriod do
  permit_params :from, :to, :billing_date

  belongs_to :subscription

  form do |f|
    f.inputs do
      f.input :from
      f.input :to
      f.input :billing_date

      f.actions
    end
  end

  show do
    attributes_table do
      row :id
      row :subscription
      row :to
      row :from
      row :created_at
      row :updated_at
    end

    panel 'Meter Events' do
      table_for resource.meter_events.includes(meter: :organization) do
        column :id
        column :meter
        column :amount
        column :current_meter_count
        column :created_at
      end
    end
  end
end
