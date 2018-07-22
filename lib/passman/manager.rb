require 'passman/crypto'
require 'json'

module Passman
  class Manager
    DEFAULT_PATH = 'passman.json'.freeze

    def initialize(file = nil)
      @file_path = DEFAULT_PATH
      @file_path = file unless file.nil?
    end

    def generate_password(length = 32)
      Passman::Crypto.generate_password(length)
    end

    def add(account, username, password, key, salt = nil)
      validate_add_arguments(account, username, password, key)
      db = database
      db[account.to_s] = {
        username: username, password: Passman::Crypto.encrypt(password, key, salt: salt)
      }
      store_data(db)
    end

    def delete(account)
      raise ArgumentError, 'No account provided.' unless valid?(account)
      db = database
      db.delete(account.to_s)
      store_data(db)
    end

    def get(account, key)
      validate_get_arguments(account, key)
      data = database[account.to_s]
      [account.to_s, { 'username' => data['username'],
                       'password' => Passman::Crypto.decrypt(data['password'], key) }]
    end

    def exist?(account)
      raise ArgumentError, 'No account provided.' unless valid?(account)
      !(!database[account.to_s])
    end

    def list
      database
    end

    private

    def validate_add_arguments(account, username, password, key)
      raise ArgumentError, 'No account provided.' unless valid?(account)
      raise ArgumentError, 'No username provided.' unless valid?(username)
      raise ArgumentError, 'No password provided.' unless valid?(password)
      raise ArgumentError, 'No key provided.' unless valid?(key)
    end

    def validate_get_arguments(account, key)
      raise ArgumentError, 'No account provided.' unless valid?(account)
      raise ArgumentError, 'No key provided.' unless valid?(key)
    end

    def valid?(argument)
      !(argument.nil? || argument.empty?)
    end

    def database
      return JSON.parse(File.read(@file_path)) if File.exist?(@file_path)
      {}
    end

    def store_data(data)
      File.delete(@file_path) if File.exist?(@file_path)
      file = File.open(@file_path, 'w+')
      file.write(JSON.generate(data))
      file.close
    end
  end
end
