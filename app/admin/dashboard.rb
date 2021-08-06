ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Recent Users' do
          table_for User.last(5) do
            column :email do |user|
              link_to(user.email, admin_user_path(user))
            end

            column :created_at
          end
        end
      end

      column do
        panel 'Recent Organizations' do
          table_for Organization.last(5) do
            column :name do |org|
              link_to(org.name, admin_organization_path(org))
            end

            column :created_at
          end
        end
      end
    end
  end
end
