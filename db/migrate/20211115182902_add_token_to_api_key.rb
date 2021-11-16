class AddTokenToApiKey < ActiveRecord::Migration[6.1]
  def change
    add_column :api_keys, :public_token, :string, default: nil
  end
end
