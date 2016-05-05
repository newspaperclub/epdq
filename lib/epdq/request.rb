# frozen_string_literal: true
require "epdq/sha_calculator"

module EPDQ
  class Request
    attr_reader :parameters

    # Initialize with a hash of parameters to be passed to ePDQ to set up the
    # transaction.
    def initialize(client, parameters = {})
      self.client = client
      self.parameters = parameters
    end

    # Returns the SHASIGN value, calculated from the other form parameters and
    # the EPDQ.sha_in.
    def shasign
      calculator = EPDQ::ShaCalculator.new(full_parameters, client.sha_in, client.sha_type)
      calculator.sha_signature
    end

    # Returns a hash of form parameters with the SHASIGN value correctly
    # calculated and included.
    def form_attributes
      {}.tap do |attributes|
        full_parameters.each do |k, v|
          attributes[k.to_s.upcase] = v.to_s unless v.to_s.empty?
        end

        attributes["SHASIGN"] = shasign
      end
    end

    def request_url
      url + endpoint
    end

    private

    TEST_URL = "https://mdepayments.epdq.co.uk/ncol/test/"
    LIVE_URL = "https://payments.epdq.co.uk/ncol/prod/"

    ENDPOINT = "orderstandard.asp"
    UTF8_ENDPOINT = "orderstandard_utf8.asp"

    attr_accessor :client
    attr_writer :parameters

    def url
      client.test_mode ? TEST_URL : LIVE_URL
    end

    def endpoint
      client.enable_utf8 ? UTF8_ENDPOINT : ENDPOINT
    end

    def full_parameters
      parameters.merge(pspid: client.pspid)
    end
  end
end
