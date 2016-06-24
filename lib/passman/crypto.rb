require 'openssl'
require 'base64'

module Passman
  class Crypto
    MINIMUM_SIZE_KEY = 32

    class << self
      def encrypt(password, key)
        cipher = new_cipher
        cipher.encrypt
        cipher.key = sanitize_key(key)
        encrypted_password = cipher.update(password) + cipher.final
        Base64.encode64(encrypted_password)
      end

      def decrypt(encrypted_password, key)
        cipher = new_cipher
        cipher.decrypt
        cipher.key = sanitize_key(key)
        decrypted_password = cipher.update(Base64.decode64(encrypted_password))
        decrypted_password << cipher.final
      end

      private

      def new_cipher
        OpenSSL::Cipher::AES.new(256, 'CBC')
      end

      def sanitize_key(key)
        raise ArgumentError, 'No key provided.' if key.nil? || key.empty?
        sanitized = key
        sanitized += key while sanitized.length < MINIMUM_SIZE_KEY
        sanitized
      end
    end
  end
end
