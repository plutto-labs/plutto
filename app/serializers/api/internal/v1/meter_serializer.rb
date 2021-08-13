class Api::Internal::V1::MeterSerializer < ActiveModel::Serializer
  attributes :id, :name, :identifier, :meter_type
end
