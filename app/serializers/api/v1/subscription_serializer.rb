class Api::V1::SubscriptionSerializer < Api::BaseSerializer
  attributes  :id, :customer_id, :created_at, :updated_at, :active, :trial_finishes_at, :pricing_ids

  def pricing_ids
    object.pricings.pluck(:id)
  end
end
