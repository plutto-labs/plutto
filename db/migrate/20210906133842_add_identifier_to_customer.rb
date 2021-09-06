class AddIdentifierToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :identifier, :string
  end
end
