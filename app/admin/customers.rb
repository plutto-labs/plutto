ActiveAdmin.register Customer do
  permit_params :name, :email, :subscription_id
  belongs_to :organization, optional: true

  index do
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at
  filter :organization

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :subscription
      row :name
      row :email
      row :created_at
      row :updated_at
    end
  end
end
