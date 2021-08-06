class AddOrganizationToUsers < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_reference :users, :organization, foreign_key: true, index: true
    end
  end
end
