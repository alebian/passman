require 'spec_helper'

describe Passman::PasswordGenerator do
  let!(:length) { 16 }
  let!(:passwords) { 10_000 }

  it 'creates correct length passwords' do
    expect(Passman::PasswordGenerator.generate(length).size).to eq(length * 2)
    expect(Passman::PasswordGenerator.generate(length / 2).size).to eq(length)
  end

  it 'creates different passwords' do
    passwords_hash = {}
    passwords.times do
      passwords_hash[Passman::PasswordGenerator.generate(length)] = ''
    end
    expect(passwords_hash.size).to eq passwords
  end
end
