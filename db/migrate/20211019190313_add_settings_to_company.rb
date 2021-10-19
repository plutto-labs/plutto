class AddSettingsToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :settings, :jsonb
    Organization.update_all(settings: { send_invoices_automatically: false, charge_invoices_automatically: false })
  end
end
