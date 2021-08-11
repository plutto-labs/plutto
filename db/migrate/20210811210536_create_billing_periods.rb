class CreateBillingPeriods < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_periods do |t|
      t.datetime :from, null: false
      t.datetime :to, null: false
      t.string :identifier
      t.references :plan_subscription, null: false, foreign_key: true

      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
