class AddDefaultPlanVersionToPlans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    safety_assured {
      add_reference :plans, :default_plan_version, foreign_key: { to_table: :plan_versions }, index: false
      add_index :plans, :default_plan_version_id, algorithm: :concurrently
    }
  end
end
