ActiveAdmin.register Product do
  permit_params :name
  belongs_to :organization

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

    panel I18n.t('activerecord.models.pricing', count: 2) do
      table_for resource.pricings do
        column(:id) do |pricing|
          link_to(pricing.id,
                  admin_organization_pricings_path(organization_id: resource.id,
                                                   pricing_id: pricing.id))
        end
        column :name
        column :created_at
      end
    end
  end
end
