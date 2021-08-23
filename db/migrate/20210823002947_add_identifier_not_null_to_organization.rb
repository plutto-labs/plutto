class AddIdentifierNotNullToOrganization < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    safety_assured do
      change_column_null :organizations, :identifier, false
      add_index :organizations, :identifier, algorithm: :concurrently, unique: true
    end
  end
end
