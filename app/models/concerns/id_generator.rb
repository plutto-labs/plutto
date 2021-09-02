module IdGenerator
  extend ActiveSupport::Concern

  def init_id(prefix)
    self.id = loop do
      random_token = build_token(prefix)
      break random_token unless ensure_unique_token(random_token)
    end
  end

  private

  def build_token(prefix)
    random_token = SecureRandom.hex(12)
    "#{prefix}_#{random_token}"
  end

  def ensure_unique_token(token)
    self.class.exists?(id: token)
  end
end
