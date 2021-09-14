class AddUniqueIndexToCustomer < ActiveRecord::Migration[6.1]
  def change
    safety_assured {
      add_index :customers, [:organization_id, :identifier], unique: true
    }
  end
end
