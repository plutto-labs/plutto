class CreateBillingPeriods < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_periods, id: :string do |t|
      t.datetime :from, null: false
      t.datetime :to, null: false
      t.references :plan_subscription, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
