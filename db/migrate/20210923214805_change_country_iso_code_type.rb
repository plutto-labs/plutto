class ChangeCountryIsoCodeType < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    safety_assured {
      remove_column :billing_informations, :country_iso_code
      add_column :billing_informations, :country_iso_code, :integer
    }
  end
end
