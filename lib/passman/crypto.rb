require 'openssl'
require 'base64'

module Passman
  class Crypto
    class << self
      def encrypt(password, key)
        cipher = new_cipher
        cipher.encrypt
        cipher.key = key
        encrypted_password = cipher.update(password) + cipher.final
        Base64.encode64(encrypted_password)
      end

      def decrypt(encrypted_password, key)
        cipher = new_cipher
        cipher.decrypt
        cipher.key = key
        decrypted_password = cipher.update(Base64.decode64(encrypted_password))
        decrypted_password << cipher.final
      end

      private

      def new_cipher
        OpenSSL::Cipher::AES.new(256, 'CBC')
      end
    end
  end
end
