class AddDefaultPlanVersionToPlans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    safety_assured {
      add_column :plans, :default_plan_version_id, :string
      add_foreign_key :plans, :plan_versions, column: :default_plan_version_id
      add_index :plans, :default_plan_version_id, algorithm: :concurrently
    }
  end
end
