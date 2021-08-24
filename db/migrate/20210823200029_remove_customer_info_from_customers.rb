class RemoveCustomerInfoFromCustomers < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :customers, :customer_info, :jsonb }
  end
end
