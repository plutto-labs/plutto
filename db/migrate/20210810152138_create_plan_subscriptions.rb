class CreatePlanSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_subscriptions do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :plan_version, null: false, foreign_key: true
      t.string :identifier, null: false

      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
