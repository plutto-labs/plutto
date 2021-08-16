class RenameNameToVersionOnPlanVersions < ActiveRecord::Migration[6.1]
  def change
    safety_assured {
      remove_column :plan_versions, :name, :string
      add_column :plan_versions, :version, :integer, limit: 2
    }
  end
end
