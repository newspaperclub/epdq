require 'digest/sha1'
require 'digest/sha2'

module EPDQ
  class ShaCalculator

    def initialize(parameters = {}, sha, sha_type)
      @parameters = parameters
      @sha = sha
      @sha_type = sha_type
    end

    def sha_signature
      raise "missing or empty sha parameter" unless @sha && @sha.length > 0

      buffer = ""

      @parameters.keys.sort.each do |key|
        value = @parameters[key]
        if value && value.to_s.length > 0
          buffer << "#{key.upcase}=#{value}#{@sha}"
        end
      end

      case @sha_type.to_sym
      when :sha1
        Digest::SHA1.hexdigest(buffer).upcase
      when :sha256
        Digest::SHA256.hexdigest(buffer).upcase
      when :sha512
        Digest::SHA512.hexdigest(buffer).upcase
      else
        raise "Unexpected sha_type"
      end
    end

  end
end
