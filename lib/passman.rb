require_relative 'passman/crypto'
require 'passman/password_generator'
require 'passman/version'
require 'json'

module Passman
  DEFAULT_FILE = 'passman.json'.freeze

  def self.generate_password(length)
    Passman::PasswordGenerator.generate(length / 2)
  end

  def self.add(account, username, encrypted_password, file = nil)
    path = DEFAULT_FILE if file.nil?
    db = database(path)
    db[account.to_s] = { username: username, password: encrypted_password }
    write_database(db, path)
  end

  def self.delete(account, file = nil)
    path = DEFAULT_FILE if file.nil?
    db = database(path)
    db.delete(account.to_s)
    write_database(db, path)
  end

  def self.get(account, key, file = nil)
    path = DEFAULT_FILE if file.nil?
    db = database(path)
    db[account.to_s]
  end

  def self.database(file)
    return JSON.parse(File.read(file)) if File.exist?(file)
    {}
  end

  def self.write_database(data, path)
    File.delete(path) if File.exist?(path)
    file = File.open(path, 'w+')
    file.write(JSON.generate(data))
    file.close
  end
end
