# frozen_string_literal: true
require "epdq/client"
require "epdq/request"
require "epdq/response"

module EPDQ
  class MissingOrEmptyShasign < StandardError; end
end
