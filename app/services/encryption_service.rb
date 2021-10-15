class EncryptionService
  KEY = ActiveSupport::KeyGenerator.new(
    ENV["SECRET_KEY_BASE"].presence || 'super-sekret_key-base-2'
  ).generate_key(
    ENV["ENCRYPTION_SERVICE_SALT"].presence || 'super-sekret_salt-2',
    ActiveSupport::MessageEncryptor.key_len
  ).freeze

  private_constant :KEY

  delegate :encrypt_and_sign, :decrypt_and_verify, to: :encryptor

  def self.encrypt(value)
    new.encrypt_and_sign(value)
  end

  def self.decrypt(value)
    new.decrypt_and_verify(value)
  end

  private

  def encryptor
    ActiveSupport::MessageEncryptor.new(KEY)
  end
end
