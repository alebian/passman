require 'spec_helper'

describe Passman::Crypto do
  let!(:password) { 'ThIsIsAReAlLyStRoNgPaSsWoRdThAtIwAnTtOEnCrYpT' }
  let!(:key) { 'supermegaarchisecurekeyofmorethan32bitslong' }

  it 'encrypts the password correctly' do
    expect(Passman::Crypto.encrypt(password, key)).not_to eq password
  end

  it 'decrypts the password correctly' do
    encrypted = Passman::Crypto.encrypt(password, key)
    expect(Passman::Crypto.decrypt(encrypted, key)).to eq password
  end

  context 'when the key is short' do
    let(:key) { 'short' }

    it 'encrypts the password correctly' do
      expect(Passman::Crypto.encrypt(password, key)).not_to eq password
    end

    it 'decrypts the password correctly' do
      encrypted = Passman::Crypto.encrypt(password, key)
      expect(Passman::Crypto.decrypt(encrypted, key)).to eq password
    end
  end

  context 'when the key is empty' do
    let(:key) { '' }

    it 'fails' do
      expect { Passman::Crypto.encrypt(password, key) }.to raise_error(ArgumentError)
    end
  end

  context 'when the key is nil' do
    let(:key) { nil }

    it 'fails' do
      expect { Passman::Crypto.encrypt(password, key) }.to raise_error(ArgumentError)
    end
  end

  context 'when the key has spaces' do
    let(:key) { 'this is a key with spaces' }

    it 'encrypts the password correctly' do
      expect(Passman::Crypto.encrypt(password, key)).not_to eq password
    end

    it 'decrypts the password correctly' do
      encrypted = Passman::Crypto.encrypt(password, key)
      expect(Passman::Crypto.decrypt(encrypted, key)).to eq password
    end
  end
end
