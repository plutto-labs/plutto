class ChangeDocumentIdToInvoices < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      change_column :invoices, :document_id, :string
    end
  end
end
