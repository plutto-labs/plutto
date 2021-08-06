ActiveAdmin.register Organization do
  permit_params :name

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
  end
end
