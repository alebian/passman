require 'securerandom'

module Passman
  class PasswordGenerator
    def self.generate(length)
      SecureRandom.hex(length)
    end
  end
end
