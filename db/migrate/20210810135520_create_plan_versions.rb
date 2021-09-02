class CreatePlanVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_versions, id: :string do |t|
      t.references :plan, null: false, foreign_key: true, type: :string
      t.references :previous_version, index: true, foreign_key: { to_table: :plan_versions }, type: :string
      t.boolean :deployed, default: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
