class AddMeterToPriceLogics < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    safety_assured do
      add_reference :price_logics, :meter, foreign_key: true, index: true, type: :string
    end
  end
end
