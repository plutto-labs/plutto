ActiveAdmin.register Meter do
  belongs_to :organization

  show do
    attributes_table do
      row :id
      row :organization
      row :name
      row :created_at
      row :updated_at
    end
  end
end
