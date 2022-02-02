ActiveAdmin.register PermissionGroup do
  permit_params :name
  belongs_to :organization

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column :zombie
    actions
  end

  filter :name
  filter :created_at
  filter :organization

  form do |f|
    f.inputs do
      f.input :name
      f.input :zombie
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
      row :zombie
    end
  end
end
