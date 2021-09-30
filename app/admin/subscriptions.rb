ActiveAdmin.register Subscription do
  permit_params :name
  belongs_to :pricing

  index do
    selectable_column
    id_column
    column :created_at
    actions
  end

  filter :created_at

  form do |f|
    f.inputs do
      f.input :customer
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end
  end
end
