class Api::V1::BillingInformationSerializer < Api::BaseSerializer
  attributes :city, :country_iso_code, :state, :address, :zip, :tax_id, :activity,
             :legal_name, :phone
end
