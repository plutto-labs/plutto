ActiveAdmin.register Customer do
  permit_params :name, :email, :subscription_id
  belongs_to :organization, optional: true

  index do
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
      f.input :email
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :active_subscription
      row :name
      row :email
      row :created_at
      row :updated_at
      row :organization

      panel I18n.t('activerecord.models.invoice', count: 2) do
        table_for resource.invoices do
          column :id do |invoice|
            link_to invoice.id, admin_invoice_path(invoice)
          end
          column :subtotal
          column :currency
          column :status
          column :created_at
        end
      end
    end
  end
end
