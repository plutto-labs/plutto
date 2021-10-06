class CreatePlanPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_permissions, id: :string do |t|
      t.references :plan, null: false, foreign_key: true, type: :string
      t.references :permission, null: false, foreign_key: true, type: :string
      t.integer :limit

      t.timestamps
    end
  end
end
