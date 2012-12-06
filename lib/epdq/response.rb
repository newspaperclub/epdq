require 'epdq/sha_calculator'
require 'cgi'

module EPDQ
  class Response

    def initialize(query_string)
      raw_parameters = CGI::parse(query_string)
      # collapse the array that CGI::parse produces for each value
      raw_parameters.each do |k, v|
        raw_parameters[k] = v.first
      end

      @shasign = raw_parameters.delete("SHASIGN")
      @raw_parameters = raw_parameters
    end

    def valid_shasign?
      raise "missing or empty SHASIGN parameter" unless @shasign && @shasign.length > 0

      calculated_sha_out == @shasign
    end

    def parameters
      {}.tap do |hash|
        @raw_parameters.each do |k, v|
          hash[k.downcase.to_sym] = v
        end
      end
    end

    private

    def calculated_sha_out
      calculator = EPDQ::ShaCalculator.new(@raw_parameters, EPDQ.sha_out, EPDQ.sha_type)
      calculator.sha_signature
    end

  end
end
