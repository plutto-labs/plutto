ActiveAdmin.register User do
  permit_params :email, :password, :organization_id
  belongs_to :organization, optional: true

  index do
    id_column
    column :email
    column :created_at
    actions
  end

  filter :email
  filter :created_at
  filter :organization

  show do
    attributes_table do
      row :id
      row :email
      row :created_at
      row :updated_at
      row :organization
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password if f.object.new_record?
      f.input :organization
    end

    f.actions
  end
end
