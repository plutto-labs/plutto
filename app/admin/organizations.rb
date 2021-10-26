ActiveAdmin.register Organization do
  permit_params :name, :settings

  action_item :create_product, only: :show do
    link_to(I18n.t('active_admin.resources.organization.new_product'),
            new_admin_organization_product_path(resource))
  end

  action_item :create_customer, only: :show do
    link_to(I18n.t('active_admin.resources.organization.new_customer'),
            new_admin_organization_customer_path(resource))
  end

  action_item :create_user, only: :show do
    link_to(I18n.t('active_admin.resources.organization.new_user'),
            new_admin_organization_user_path(resource))
  end

  index do
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :settings
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :settings do |model|
        tag.pre JSON.pretty_generate(model.settings)
      end
      row :created_at
      row :updated_at
    end

    panel I18n.t('activerecord.models.user', count: 2) do
      table_for resource.users do
        column :user
        column :created_at
        column(:admin) do |user|
          user.is_admin_of?(resource) ? status_tag('yes') : status_tag('no')
        end
      end
    end

    panel I18n.t('activerecord.models.product', count: 2) do
      table_for resource.products do
        column(:id) do |product|
          link_to(product.id,
                  admin_organization_products_path(organization_id: resource.id,
                                                   product_id: product.id))
        end
        column :name
        column :created_at
      end
    end

    panel I18n.t('activerecord.models.meter', count: 2) do
      table_for resource.meters do
        column(:id) do |meter|
          link_to(meter.id,
                  admin_organization_meters_path(organization_id: resource.id, meter_id: meter.id))
        end
        column :name
        column :created_at
      end
    end
  end
end
