class AddBillsAtToPlans < ActiveRecord::Migration[6.1]
  def change
    safety_assured {
      add_column :plans, :bills_at, :integer, default: 0
    }
  end
end
