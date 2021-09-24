# frozen_string_literal: true

class ChangeExistingInvoicesDetails < ActiveRecord::Migration[6.1]
  def up
    Invoice.all.each do |invoice|
      if invoice.details.is_a?(Hash)
        invoice.update!(details: invoice.details.values)
      end
    end
  end

  def down; end
end
