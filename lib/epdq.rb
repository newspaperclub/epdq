require 'epdq/request'
require 'epdq/response'

module EPDQ
  class MissingOrEmptyShasign < StandardError; end

  def self.test_mode=(test_mode)
    @@test_mode = !!test_mode
  end

  def self.test_mode
    @@test_mode
  end

  def self.enable_utf8=(enable_utf8)
    @@enable_utf8 = !!enable_utf8
  end

  def self.enable_utf8
    @@enable_utf8
  end

  def self.sha_in=(sha_in)
    @@sha_in = sha_in
  end

  def self.sha_in
    @@sha_in
  end

  def self.sha_out=(sha_out)
    @@sha_out = sha_out
  end

  def self.sha_out
    @@sha_out
  end

  def self.sha_type=(sha_type)
    @@sha_type = sha_type
  end

  def self.sha_type
    @@sha_type
  end

  def self.pspid=(pspid)
    @@pspid = pspid
  end

  def self.pspid
    @@pspid
  end

end
