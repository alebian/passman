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
end
