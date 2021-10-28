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

    meter_events = resource.meter_events.includes(meter: :organization)

    panel 'Meter Events' do
      paginated_collection(
        meter_events.page(params[:meter_events_page]).per(15),
        param_name: 'meter_events_page'
      ) do
        table_for(collection) do
          column :id
          column :meter
          column :amount
          column :current_meter_count
          column :created_at
        end
      end
    end
  end
end
