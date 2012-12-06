require 'digest/sha1'
require 'digest/sha2'

module EPDQ
  class Request

    attr_reader :sha_in, :sha_type, :parameters

    TEST_URL = "https://mdepayments.epdq.co.uk/ncol/test/orderstandard.asp"
    LIVE_URL = "https://mdepayments.epdq.co.uk/ncol/prod/orderstandard.asp"

    def initialize(options = {})
      @sha_in = options.delete(:sha_in)
      raise "missing sha_in parameter" unless @sha_in && @sha_in.length > 0

      @sha_type = (options.delete(:sha_type) || :sha1).to_sym
      if ![:sha1, :sha256, :sha512].include?(@sha_type)
        raise "unexpected sha_type parameter: should be one of sha1, sha256 or sha512" 
      end

      @parameters = options
    end

    def shasign
      buffer = ""

      @parameters.keys.sort.each do |key|
        value = @parameters[key]
        if value && value.to_s.length > 0
          buffer << "#{key.upcase}=#{value}#{@sha_in}"
        end
      end

      case @sha_type
      when :sha1
        Digest::SHA1.hexdigest(buffer).upcase
      when :sha256
        Digest::SHA256.hexdigest(buffer).upcase
      when :sha512
        Digest::SHA512.hexdigest(buffer).upcase
      end
    end

    def form_attributes
      {}.tap do |attributes|
        @parameters.each do |k, v|
          if v && v.to_s.length > 0
            attributes[k.to_s.upcase] = v.to_s
          end
        end

        attributes["SHASIGN"] = self.shasign
      end
    end
  end
end
