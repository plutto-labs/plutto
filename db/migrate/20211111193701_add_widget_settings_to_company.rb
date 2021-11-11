class AddWidgetSettingsToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :widget_settings, :jsonb
  end
end
