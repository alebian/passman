require 'securerandom'

module Passman
  class PasswordGenerator
    def self.generate(length)
      SecureRandom.hex(length.to_i / 2)
    end
  end
end
