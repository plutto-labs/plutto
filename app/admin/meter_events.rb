ActiveAdmin.register MeterEvent do
  belongs_to :meter_count

  show do
    attributes_table do
      row :id
      row :identifier
      row :customer
      row :meter_count
      row :timestamp
      row :amount
      row :action
      row :created_at
      row :updated_at
    end
  end
end
