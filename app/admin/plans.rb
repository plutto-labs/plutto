ActiveAdmin.register Plan do
  permit_params :name
  belongs_to :organization

  action_item :new_plan_version, only: :show do
    link_to I18n.t('active_admin.resources.plan.new_plan_version'),
            new_admin_plan_plan_version_path(resource)
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

    panel I18n.t('activerecord.models.plan_version', count: 2) do
      table_for resource.plan_versions do
        column(:id) do |plan_version|
          link_to(plan_version.id,
                  admin_plan_plan_versions_path(plan_id: resource.id,
                                                plan_version_id: plan_version.id))
        end
        column :name
        column :created_at
      end
    end
  end
end
