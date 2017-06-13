# frozen_string_literal: true
require "epdq/sha_calculator"
require "cgi"

module EPDQ
  class Response
    def initialize(client, query_string)
      raw_parameters = CGI.parse(query_string)
      # collapse the array that CGI::parse produces for each value
      raw_parameters.each do |k, v|
        raw_parameters[k] = v.first
      end

      self.client = client
      self.shasign = raw_parameters.delete("SHASIGN")
      self.raw_parameters = raw_parameters
    end

    def valid_shasign?
      raise(EPDQ::MissingOrEmptyShasign, "missing or empty SHASIGN parameter") unless shasign && !shasign.empty?
      calculated_sha_out == @shasign
    end

    def parameters
      {}.tap do |hash|
        raw_parameters.each do |k, v|
          hash[k.downcase.to_sym] = v
        end
      end
    end

    private

    attr_accessor :client, :shasign, :raw_parameters

    def calculated_sha_out
      calculator = EPDQ::ShaCalculator.new(raw_parameters, client.sha_out, client.sha_type)
      calculator.sha_signature
    end
  end
end
