# frozen_string_literal: true

class AddIdentifierToOrganizations < ActiveRecord::Migration[6.1]
  def up
    Organization.all.each do |org|
      org.identifier = org.init_identifier('organization') if org.identifier.blank?
      org.save
    end
  end

  def down
    nil
  end
end
