ActiveAdmin.register Subscription do
  permit_params :name, :customer_id, pricing_ids: []

  index do
    selectable_column
    id_column
    column :created_at
    actions
  end

  filter :created_at

  form do |f|
    f.inputs do
      f.input :customer
      f.input :pricings, collection: Pricing.where(
        product_id: resource.customer.organization.products
      ).map { |p| [p.name, p.id] }
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :pricings
      row :created_at
      row :updated_at
    end

    panel 'Billing Periods' do
      table_for resource.billing_periods do
        column(:id) do |billing_period|
          link_to(billing_period.id,
                  admin_subscription_billing_period_path(subscription_id: resource.id,
                                                         id: billing_period.id))
        end
        column :from
        column :to
        column :billing_date
        column :created_at
      end
    end
  end
end
