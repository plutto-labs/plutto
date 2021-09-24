FactoryBot.define do
  factory :billing_information do
    customer
    city { 'San Francisco' }
    country_iso_code { 0 }
    state { 'California' }
    zip { '112256' }
    legal_name { 'Plutto Inc' }
    tax_id { '73245432-1' }
    phone { '+569 92680522' }
  end
end
