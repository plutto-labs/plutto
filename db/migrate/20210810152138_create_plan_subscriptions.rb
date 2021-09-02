class CreatePlanSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_subscriptions, id: :string do |t|
      t.references :customer, null: false, foreign_key: true, type: :string
      t.references :plan_version, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
