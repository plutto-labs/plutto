class CreatePriceLogics < ActiveRecord::Migration[6.1]
  def change
    create_table :price_logics, id: :string do |t|
      t.string :type, null: false
      t.references :plan_version, null: false, foreign_key: true, type: :string
      t.monetize :price

      t.timestamps
    end
  end
end
