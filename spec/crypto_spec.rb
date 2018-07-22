require 'spec_helper'

describe Passman::Crypto do
  describe 'encrypting data' do
    let!(:password) { 'ThIsIsAReAlLyStRoNgPaSsWoRdThAtIwAnTtOEnCrYpT' }
    let!(:key) { 'supermegaarchisecurekeyofmorethan32bitslong' }

    it 'encrypts the password correctly' do
      expect(described_class.encrypt(password, key)).not_to eq password
    end

    it 'decrypts the password correctly' do
      encrypted = described_class.encrypt(password, key)
      expect(described_class.decrypt(encrypted, key)).to eq password
    end

    context 'when the key is short' do
      let(:key) { 'short' }

      it 'encrypts the password correctly' do
        expect(described_class.encrypt(password, key)).not_to eq password
      end

      it 'decrypts the password correctly' do
        encrypted = described_class.encrypt(password, key)
        expect(described_class.decrypt(encrypted, key)).to eq password
      end
    end

    context 'when the key is empty' do
      let(:key) { '' }

      it 'fails' do
        expect { described_class.encrypt(password, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the key is nil' do
      let(:key) { nil }

      it 'fails' do
        expect { described_class.encrypt(password, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the key has spaces' do
      let(:key) { 'this is a key with spaces' }

      it 'encrypts the password correctly' do
        expect(described_class.encrypt(password, key)).not_to eq password
      end

      it 'decrypts the password correctly' do
        encrypted = described_class.encrypt(password, key)
        expect(described_class.decrypt(encrypted, key)).to eq password
      end
    end
  end

  describe '.generate_password' do
    context 'when using default values' do
      it 'creates the password with correct size' do
        expect(described_class.generate_password.size).to eq(described_class::MINIMUM_SIZE_KEY)
      end
    end

    context 'when using options' do
      it 'uses the upcase dictionary correctly' do
        password = described_class.generate_password(1, minimum_upcase_count: 1)
        expect(described_class::UPCASE_DICTIONARY.include?(password)).to be_truthy
      end

      it 'uses the numbers dictionary correctly' do
        password = described_class.generate_password(1, minimum_numbers_count: 1)
        expect(described_class::NUMBERS_DICTIONARY.include?(password)).to be_truthy
      end

      it 'uses the symbols dictionary correctly' do
        password = described_class.generate_password(1, minimum_symbols_count: 1)
        expect(described_class::SYMBOLS_DICTIONARY.include?(password)).to be_truthy
      end
    end
  end
end
