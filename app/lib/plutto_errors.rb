module PluttoErrors
  class PaymentError < StandardError; end

  class InvalidTransition < StandardError; end
end
