class AddFieldsToPaymentMethod < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_methods, :currency, :integer
    add_column :payment_methods, :last_4_digits, :string
    add_column :payment_methods, :card_brand, :integer
  end
end
