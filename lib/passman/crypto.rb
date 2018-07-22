require 'openssl'
require 'bcrypt'
require 'base64'

module Passman
  class Crypto
    AVAILABLE_CIPHERS   = %w[aes-256-cbc aes-128-gcm aes-256-gcm].freeze
    MINIMUM_SIZE_KEY    = 32
    DOWNCASE_DICTIONARY = ('a'..'z').to_a.freeze
    UPCASE_DICTIONARY   = ('A'..'Z').to_a.freeze
    NUMBERS_DICTIONARY  = (0..9).to_a.map(&:to_s).freeze
    SYMBOLS_DICTIONARY  = %w[! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ ] ^ _ ` { | } ~].freeze
    FULL_DICTIONARY     = (
      DOWNCASE_DICTIONARY + UPCASE_DICTIONARY + NUMBERS_DICTIONARY + SYMBOLS_DICTIONARY
    )

    class << self
      def encrypt(password, key, algorithm: AVAILABLE_CIPHERS[0], salt: nil)
        cipher = new_cipher(algorithm)
        cipher.encrypt
        strong_key, salt = sanitize_key(key, salt)
        cipher.key = strong_key
        encrypted_password = cipher.update(password) + cipher.final
        [salt, Base64.strict_encode64(encrypted_password)].join(' ')
      end

      def decrypt(encrypted_password, key, algorithm: AVAILABLE_CIPHERS[0])
        cipher = new_cipher(algorithm)
        cipher.decrypt
        salt, enc_password = encrypted_password.split(' ')
        strong_key, = sanitize_key(key, salt)
        cipher.key = strong_key
        decrypted_password = cipher.update(Base64.strict_decode64(enc_password))
        decrypted_password << cipher.final
      end

      def generate_password(
        length = MINIMUM_SIZE_KEY,
        minimum_upcase_count: 0, minimum_numbers_count: 0, minimum_symbols_count: 0
      )
        expected_characters =
          NUMBERS_DICTIONARY.sample(minimum_numbers_count) +
          UPCASE_DICTIONARY.sample(minimum_upcase_count) +
          SYMBOLS_DICTIONARY.sample(minimum_symbols_count)
        raise ArgumentError if expected_characters.size > length
        expected_characters += FULL_DICTIONARY.sample(length - expected_characters.size)
        expected_characters.shuffle.join
      end

      private

      def new_cipher(algorithm)
        raise ArgumentError, 'Invalid cipher' unless AVAILABLE_CIPHERS.include?(algorithm)
        OpenSSL::Cipher.new(algorithm)
      end

      def sanitize_key(key, salt = nil)
        raise ArgumentError, 'No key provided.' if key.nil? || key.empty?
        salt = BCrypt::Engine.generate_salt if salt.nil?
        password = BCrypt::Password.new(BCrypt::Engine.hash_secret(key, salt))
        [password, salt]
      end
    end
  end
end
