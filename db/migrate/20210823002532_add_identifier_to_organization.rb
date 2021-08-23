class AddIdentifierToOrganization < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_column :organizations, :identifier, :string
  end
end
