require 'spec_helper'
require 'json'

describe Passman::Manager do
  subject(:manager) { described_class.new(file_path) }
  let(:file_path)   { './spec/passman.json' }
  let(:account)     { 'test_account' }
  let(:username)    { 'test_username' }
  let(:password)    { 'test_password' }
  let(:key)         { 'test_key' }
  let!(:salt)       { BCrypt::Engine.generate_salt }

  describe '#generate_password' do
    let!(:length) { 32 }
    let!(:passwords) { 10_000 }

    it 'creates correct length passwords' do
      expect(subject.generate_password(length).size).to eq(length)
    end

    it 'creates different passwords' do
      passwords_hash = {}
      passwords.times do
        passwords_hash[subject.generate_password(length)] = ''
      end
      expect(passwords_hash.size).to eq passwords
    end
  end

  describe '#add' do
    it 'stores the data' do
      subject.add(account, username, password, key, salt)
      json = JSON.parse(File.read(file_path))
      expect(json).to eq(
        account => {
          'username' => username,
          'password' => Passman::Crypto.encrypt(password, key, salt: salt)
        }
      )
    end

    context 'when the account is empty' do
      let(:account) { '' }

      it 'fails' do
        expect { subject.add(account, username, password, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the account is nil' do
      let(:account) { nil }

      it 'fails' do
        expect { subject.add(account, username, password, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the username is empty' do
      let(:username) { '' }

      it 'fails' do
        expect { subject.add(account, username, password, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the username is nil' do
      let(:username) { nil }

      it 'fails' do
        expect { subject.add(account, username, password, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the password is empty' do
      let(:password) { '' }

      it 'fails' do
        expect { subject.add(account, username, password, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the password is nil' do
      let(:password) { nil }

      it 'fails' do
        expect { subject.add(account, username, password, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the key is empty' do
      let(:key) { '' }

      it 'fails' do
        expect { subject.add(account, username, password, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the key is nil' do
      let(:key) { nil }

      it 'fails' do
        expect { subject.add(account, username, password, key) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#delete' do
    it 'deletes the data' do
      subject.add(account, username, password, key)
      subject.delete(account)
      json = JSON.parse(File.read(file_path))
      expect(json).to eq({})
    end

    context 'when the account is empty' do
      let(:account) { '' }

      it 'fails' do
        expect { subject.delete(account) }.to raise_error(ArgumentError)
      end
    end

    context 'when the account is nil' do
      let(:account) { nil }

      it 'fails' do
        expect { subject.delete(account) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#get' do
    it 'retreives the data' do
      subject.add(account, username, password, key)
      expect(subject.get(account, key)).to eq([account.to_s, { 'username' => username,
                                                               'password' => password }])
    end

    context 'when the account is empty' do
      let(:account) { '' }

      it 'fails' do
        expect { subject.get(account, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the account is nil' do
      let(:account) { nil }

      it 'fails' do
        expect { subject.get(account, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the key is empty' do
      let(:key) { '' }

      it 'fails' do
        expect { subject.get(account, key) }.to raise_error(ArgumentError)
      end
    end

    context 'when the key is nil' do
      let(:key) { nil }

      it 'fails' do
        expect { subject.get(account, key) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#exist?' do
    it 'returns true when exists' do
      subject.add(account, username, password, key)
      expect(subject.exist?(account)).to be_truthy
    end

    it 'returns true when does not exist' do
      subject.add(account, username, password, key)
      expect(subject.exist?('no_exist')).to be_falsey
    end

    context 'when the account is empty' do
      let(:account) { '' }

      it 'fails' do
        expect { subject.exist?(account) }.to raise_error(ArgumentError)
      end
    end

    context 'when the account is nil' do
      let(:account) { nil }

      it 'fails' do
        expect { subject.exist?(account) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#list' do
    it 'shows the data' do
      subject.add(account, username, password, key, salt)
      expect(subject.list).to eq(
        account => {
          'username' => username, 'password' => Passman::Crypto.encrypt(password, key, salt: salt)
        }
      )
    end

    it 'shows empty hash if no data is stored' do
      subject.delete(account)
      expect(subject.list).to eq({})
    end
  end
end
