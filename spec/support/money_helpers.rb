['USD', 'CLP'].each do |currency|
  define_method(currency.downcase) do |value = nil|
    return Money::Currency.new(currency) if value.nil?

    Money.new(value, currency)
  end
end
