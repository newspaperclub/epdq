# frozen_string_literal: true
require "digest/sha1"
require "digest/sha2"

module EPDQ
  class ShaCalculator
    def initialize(parameters, secret, sha_type)
      self.parameters = parameters
      self.secret = secret
      self.sha_type = sha_type
    end

    def sha_signature
      raise "missing or empty sha parameter" unless secret && !secret.empty?

      begin
        Digest.const_get(sha_type.upcase).hexdigest(signature).upcase
      rescue NameError
        raise "Unexpected sha_type"
      end
    end

    private

    attr_accessor :parameters, :secret, :sha_type

    def signature
      parameters
        .to_a
        .reject { |_, value| value.to_s.empty? }
        .sort_by { |key, _| key.upcase }
        .map { |key, value| "#{key.to_s.upcase}=#{value}#{secret}" }
        .join("")
    end
  end
end
