class ChangeSubcriptionNullColumns < ActiveRecord::Migration[6.1]
  def change
    safety_assured{
      change_column :subscriptions, :bills_at, :integer, null: false
      change_column :subscriptions, :billing_period_duration, :string, null: false
    }
  end
end
