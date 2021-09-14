CURRENCIES = JSON.parse(File.read(File.expand_path('../currencies.json', __dir__)))
LEDGERIZER_CURRENCIES = CURRENCIES.keys.map &:to_sym

Ledgerizer.setup do |conf|
end
