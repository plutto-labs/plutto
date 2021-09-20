class Api::BaseSerializer < ActiveModel::Serializer
  def deep_serialize?
    true if instance_options.present? && instance_options[:deep_serialize]
  end
end
