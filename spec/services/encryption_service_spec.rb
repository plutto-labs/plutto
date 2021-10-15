describe EncryptionService do
  before do
    allow(ENV).to receive(:[]).with("ENCRYPTION_SERVICE_SALT").and_return('sekret')
  end

  let(:key) do
    "invoice|invoice_3052749d8c4a54ae2f772884||customer|customer_b3f623b6ddbb5f38fde7442a"
  end

  let(:encrypted_key) do
    "N/4ZuWC8GWTNN+92X4JvnWtkWqRVVCUnAQHCr0mY9s/nCLbgm4bi2eHRdkZJkjkqfplls+u/foLMRP7f+WOe"\
    "G/Hmktji6uV25yH6KR3e0foPhosMZpMgrWEDmlkw1g==--ws7590+GCl8WUg5P--gSksaoKM528liBtvJHeLKw=="
  end

  describe "#encrypt" do
    let(:encryptor) { double }

    before do
      allow(described_class).to receive(:new).and_return(encryptor)
      allow(encryptor).to receive(:encrypt_and_sign).with(key).and_return('secret_hash')
    end

    it do
      expect(described_class.encrypt(key)).to eq('secret_hash')
    end
  end

  describe "#decrypt" do
    it { expect(described_class.decrypt(encrypted_key)).to eq(key) }
  end
end
