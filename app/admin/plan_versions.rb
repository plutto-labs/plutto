ActiveAdmin.register PlanVersion do
  permit_params :name
  belongs_to :plan

  action_item :new_plan_subscription, only: :show do
    link_to I18n.t('active_admin.resources.plan_version.new_plan_subscription'),
            new_admin_plan_version_plan_subscription_path(resource)
  end

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

    panel I18n.t('activerecord.models.plan_subscription', count: 2) do
      table_for resource.plan_subscriptions do
        column(:id) do |plan_version|
          link_to(admin_organization_plan_plan_versions_path(resource.organization,
                                                             resource,
                                                             plan_version))
        end
        column :customer
        column :created_at
      end
    end
  end
end
