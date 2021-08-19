class ActiveModelSerializers::Adapter::JsonApi
  def self.default_key_transform
    :unaltered
  end
end

ActiveModelSerializers.config.adapter = :json
ActiveModelSerializers.config.default_includes = '**'
