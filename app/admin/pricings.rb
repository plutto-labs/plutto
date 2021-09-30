ActiveAdmin.register Pricing do
  permit_params :name
  belongs_to :organization

  action_item :new_pricing, only: :show do
    link_to I18n.t('active_admin.resources.pricing.new_pricing'),
            new_admin_pricing_path(resource)
  end

  index do
    selectable_column
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
