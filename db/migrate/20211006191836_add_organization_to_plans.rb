class AddOrganizationToPlans < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_reference :plans, :organization, foreign_key: true, index: true, type: :string, null: false
    end
  end
end
