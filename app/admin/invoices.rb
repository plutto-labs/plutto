ActiveAdmin.register Invoice do
  permit_params :status
  belongs_to :customer, optional: true
  includes :customer

  index do
    id_column
    column :customer
    column :subtotal
    column :status
    column :created_at
    actions
  end

  filter :customer
  filter :created_at
  filter :subtotal

  show do
    attributes_table do
      row :id
      row :details do |model|
        tag.pre JSON.pretty_generate(model.details)
      end
      row :billing_information do |model|
        tag.pre JSON.pretty_generate(model.billing_information)
      end
      row :subtotal
      row :tax
      row :discount
    end
  end
end
