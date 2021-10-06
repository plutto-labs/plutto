class AddOrganizationToPermissions < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_reference :permissions, :organization, foreign_key: true, index: true, type: :string, null: false
    end
  end
end
