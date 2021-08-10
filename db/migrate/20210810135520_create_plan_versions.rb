class CreatePlanVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_versions do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :previous_version, index: true, foreign_key: { to_table: :plan_versions }
      t.boolean :deployed, default: false
      t.string :identifier, null: false
      t.string :name, null: false

      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
