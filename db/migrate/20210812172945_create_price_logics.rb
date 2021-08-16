class CreatePriceLogics < ActiveRecord::Migration[6.1]
  def change
    create_table :price_logics do |t|
      t.string :type, null: false
      t.monetize :price

      t.timestamps
    end
  end
end
