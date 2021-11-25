class Api::V1::OrganizationSerializer < Api::BaseSerializer
  attributes :widget_settings, :mercadopago_public_key

  has_many :permission_groups

  def widget_settings
    object.widget_settings.except('mercadopago_public_key', 'mercadopago_access_token')
  end

  def mercadopago_public_key
    object.widget_settings.dig('mercadopago_public_key')
  end
end
