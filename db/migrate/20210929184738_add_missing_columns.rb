class AddMissingColumns < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :pricings, :currency, :integer, default: 0
    end
  end
end
