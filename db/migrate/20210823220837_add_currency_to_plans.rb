class AddCurrencyToPlans < ActiveRecord::Migration[6.1]
  def change
    safety_assured {
      add_column :plans, :currency, :integer, default: 0, null: false
    }
  end
end
