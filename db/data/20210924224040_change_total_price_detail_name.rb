# frozen_string_literal: true

class ChangeTotalPriceDetailName < ActiveRecord::Migration[6.1]
  class MigrationInvoice < ApplicationRecord
    self.table_name = :invoices
  end

  def up
    MigrationInvoice.all.each do |invoice|
      invoice.details.each do |detail|
        if detail['total_price_cents'].present?
          new_amount = invoice.currency == 'USD' ? detail.delete('total_price_cents') / 100.0 : detail.delete('total_price_cents')
          detail['total_price'] = new_amount
        end
      end

      invoice.save!
    end
  end

  def down; end
end
