class AddCountryToPlans < ActiveRecord::Migration[6.1]
  def change
    add_column :plans, :country_iso_code, :integer
  end
end
