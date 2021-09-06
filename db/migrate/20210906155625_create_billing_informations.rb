class CreateBillingInformations < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_informations, id: :string do |t|
      t.string :legal_name
      t.string :country_iso_code, null: false
      t.string :state
      t.string :city
      t.string :address
      t.string :zip
      t.string :activity
      t.string :tax_id
      t.string :phone

      t.timestamps

      t.references :customer, null: false, foreign_key: true, index: true, type: :string
    end
  end
end
