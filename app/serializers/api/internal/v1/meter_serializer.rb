class Api::Internal::V1::MeterSerializer < ActiveModel::Serializer
  attributes :id, :name, :meter_type

  def meter_type
    I18n.t("activerecord.attributes.meter.#{object.meter_type}")
  end
end
