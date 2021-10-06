class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans, id: :string do |t|
      t.string :name
      t.monetize :price

      t.timestamps
    end
  end
end
