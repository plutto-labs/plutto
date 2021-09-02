class ApiKey < ApplicationRecord
  HMAC_SECRET_KEY = ENV.fetch('API_KEY_HMAC_SECRET_KEY')

  belongs_to :bearer, polymorphic: true

  before_create :generate_token_hmac_digest

  validates :name, presence: true

  # Virtual attribute for raw token value, allowing us to respond with the
  # API key's non-hashed token value. but only directly after creation.
  attr_accessor :token

  def self.authenticate_by_token!(token)
    digest = OpenSSL::HMAC.hexdigest 'SHA256', HMAC_SECRET_KEY, token

    find_by! token_digest: digest
  end

  # Add virtual token attribute to serializable attributes, and exclude
  # the token's HMAC digest
  def serializable_hash(options = nil)
    h = super options.merge(except: 'token_digest')
    h['token'] = token if token.present?
    h
  end

  private

  def generate_id
    init_id('api-key')
  end

  def generate_token_hmac_digest
    random_hex = "sk_live_#{SecureRandom.hex(32)}"
    self.token = random_hex

    digest = OpenSSL::HMAC.hexdigest 'SHA256', HMAC_SECRET_KEY, token
    self.token_digest = digest
  end
end

# == Schema Information
#
# Table name: api_keys
#
#  id           :string           not null, primary key
#  name         :string           not null
#  bearer_id    :string           not null
#  bearer_type  :string           not null
#  token_digest :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_api_keys_on_bearer_id_and_bearer_type  (bearer_id,bearer_type)
#  index_api_keys_on_token_digest               (token_digest) UNIQUE
#
