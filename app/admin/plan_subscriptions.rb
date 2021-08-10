ActiveAdmin.register PlanSubscription do
  permit_params :name
  belongs_to :plan_version

  index do
    selectable_column
    id_column
    column :identifier
    column :created_at
    actions
  end

  filter :identifier
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
      row :identifier
      row :name
      row :created_at
      row :updated_at
    end
  end
end
