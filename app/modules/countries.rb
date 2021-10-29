module Countries
  def self.find_by(attribute, value)
    all.find { |country| country[attribute] == value }
  end

  def self.find_by_currency(currency)
    all.find { |country| country['currencies'].include?(currency) }
  end

  def self.names
    @names ||= all.map { |c| c['nombre'] }.freeze
  end

  def self.codes
    @codes ||= all.map { |c| c['iso2'] }.freeze
  end

  def self.enum
    @enum ||= all.map { |c| [c['iso2'], c['enum_key']] }.to_h.freeze
  end

  def self.all
    @all ||= country_data.values
  end

  def self.country_data
    @country_data ||= JSON.parse(data_file)
  end

  def self.data_file
    @data_file ||= File.read(File.expand_path('../../config/countries.json', __dir__))
  end
end
