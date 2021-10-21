FactoryBot.define do
  factory :organization do
    name { 'Plutto' }
    settings do
      { send_invoices_automatically: false, charge_invoices_automatically: false }
    end
  end
end
