ActiveAdmin.register Organization do
  permit_params :name

  action_item :create_plan, only: :show do
    link_to(I18n.t('active_admin.resources.organization.new_plan'),
            new_admin_organization_plan_path(resource))
  end

  action_item :create_customer, only: :show do
    link_to(I18n.t('active_admin.resources.organization.new_customer'),
            new_admin_organization_customer_path(resource))
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

    panel I18n.t('activerecord.models.user', count: 2) do
      table_for resource.users do
        column :user
        column :created_at
        column(:admin) do |user|
          user.is_admin_of?(resource) ? status_tag('yes') : status_tag('no')
        end
      end
    end

    panel I18n.t('activerecord.models.plan', count: 2) do
      table_for resource.plans do
        column(:id) do |plan|
          link_to(plan.id,
                  admin_organization_plans_path(organization_id: resource.id, plan_id: plan.id))
        end
        column :identifier
        column :name
        column :created_at
      end
    end
  end
end
