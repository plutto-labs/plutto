ActiveAdmin.register Customer do
  permit_params :name, :email, :plan_subscription_id
  belongs_to :organization

  index do
    selectable_column
    id_column
    column :identifier
    column :name
    column :created_at
    actions
  end

  filter :identifier
  filter :name
  filter :created_at

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
      row :identifier
      row :plan_subscription
      row :name
      row :email
      row :created_at
      row :updated_at
    end
  end
end
