module Currencies
  BASE_CURRENCY = 'USD'

  def self.keys
    @keys ||= all.keys
  end

  def self.all
    @all ||= JSON.parse(data_file)
  end

  def self.data_file
    @data_file ||= File.read(File.expand_path('../../config/currencies.json', __dir__))
  end
end
