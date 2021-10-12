class AddUniqueIndexToPermissions < ActiveRecord::Migration[6.1]
  def change
    safety_assured {
      add_index :permissions, [:name, :organization_id], unique: true
    }
  end
end
