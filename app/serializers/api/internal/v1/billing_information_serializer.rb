class Api::Internal::V1::BillingInformationSerializer < ActiveModel::Serializer
  attributes :city, :country_iso_code, :state, :address, :zip, :tax_id, :activity,
             :legal_name, :phone
end
