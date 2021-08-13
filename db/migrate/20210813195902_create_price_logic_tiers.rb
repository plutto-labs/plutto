class CreatePriceLogicTiers < ActiveRecord::Migration[6.1]
  def change
    create_table :price_logic_tiers do |t|
      t.float :upper_limit, null: false
      t.float :lower_limit, null: false
      t.monetize :price, null: false
      t.integer :index, null: false

      t.references :tierable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
