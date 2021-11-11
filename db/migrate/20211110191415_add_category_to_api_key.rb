class AddCategoryToApiKey < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :api_keys, :category, :integer, default: 0, null: false
    end
  end
end
