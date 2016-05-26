# frozen_string_literal: true
module EPDQ
  class Client
    ATTRIBUTES = [
      :pspid,
      :sha_in,
      :sha_out,
      :sha_type,
      :test_mode,
      :enable_utf8
    ].freeze

    attr_reader(*ATTRIBUTES)

    # rubocop:disable Metrics/ParameterLists
    def initialize(pspid:, sha_in:, sha_out:, sha_type: :sha512, test_mode: true, enable_utf8: true)
      self.pspid = pspid
      self.sha_in = sha_in
      self.sha_out = sha_out
      self.sha_type = sha_type
      self.test_mode = test_mode
      self.enable_utf8 = enable_utf8
    end
    # rubocop:enable Metrics/ParameterLists

    def request(parameters = {})
      EPDQ::Request.new(self, parameters)
    end

    def response(query_string = "")
      EPDQ::Response.new(self, query_string)
    end

    private

    attr_writer(*ATTRIBUTES)
  end
end
