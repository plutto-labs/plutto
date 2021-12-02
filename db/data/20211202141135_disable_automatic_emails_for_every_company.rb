# frozen_string_literal: true

class DisableAutomaticEmailsForEveryCompany < ActiveRecord::Migration[6.1]
  def up
    Organization.update_all(settings: { send_invoices_automatically: false, charge_invoices_automatically: false })
  end

  def down; end
end
