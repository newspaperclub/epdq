# frozen_string_literal: true
require "test_helper"

class RequestTest < Test::Unit::TestCase
  setup do
    @client_config = {
      pspid: "MyPSPID",
      sha_in: "Mysecretsig1875!?",
      sha_out: "Myshaout"
    }
  end

  test "shasign (sha1) calculates correctly" do
    # this sample taken from the documentation available here:
    # https://mdepayments.epdq.co.uk/ncol/ePDQ_e-Com-ADV_EN.pdf
    client = EPDQ::Client.new(**@client_config.merge(sha_type: :sha1))

    options = {
      orderid: "1234",
      amount: 1500,
      currency: "EUR",
      language: "en_US"
    }

    request = EPDQ::Request.new(client, options)

    assert_equal "F4CC376CD7A834D997B91598FA747825A238BE0A", request.shasign
  end

  test "shasign (sha256) calculates correctly" do
    client = EPDQ::Client.new(**@client_config.merge(sha_type: :sha256))

    options = {
      orderid: "1234",
      amount: 1500,
      currency: "EUR",
      language: "en_US"
    }

    request = EPDQ::Request.new(client, options)

    assert_equal "E019359BAA3456AE5A986B6AABD22CF1B3E09438739E97F17A7F61DF5A11B30F", request.shasign
  end

  test "shasign (sha512) calculates correctly" do
    client = EPDQ::Client.new(**@client_config)

    options = {
      orderid: "1234",
      amount: 1500,
      currency: "EUR",
      language: "en_US"
    }

    request = EPDQ::Request.new(client, options)

    assert_equal "D1CFE8833A297D0922E908B2B44934B09EE966EF1584DC0D696304E07BB58BA71973C2383C831D878D8A243BB7D7DFFFBE53CEE21955CDFEF44FE82E551F859D", request.shasign
  end

  test "form_attributes" do
    # this sample taken from the documentation available here:
    # https://mdepayments.epdq.co.uk/ncol/ePDQ_e-Com-ADV_EN.pdf
    client = EPDQ::Client.new(**@client_config.merge(sha_type: :sha1))

    options = {
      orderid: "1234",
      amount: 1500,
      currency: "EUR",
      language: "en_US"
    }

    request = EPDQ::Request.new(client, options)

    form_attributes = request.form_attributes

    assert_equal form_attributes.keys.length, 6
    assert_equal form_attributes["AMOUNT"], "1500"
    assert_equal form_attributes["CURRENCY"], "EUR"
    assert_equal form_attributes["LANGUAGE"], "en_US"
    assert_equal form_attributes["ORDERID"], "1234"
    assert_equal form_attributes["PSPID"], "MyPSPID"
    assert_equal form_attributes["SHASIGN"], "F4CC376CD7A834D997B91598FA747825A238BE0A"
  end

  test "request_url in test mode" do
    client = EPDQ::Client.new(**@client_config.merge(
      test_mode: true,
      enable_utf8: false
    ))

    request = EPDQ::Request.new(client)

    assert_equal "https://mdepayments.epdq.co.uk/ncol/test/orderstandard.asp", request.request_url
  end

  test "request_url in live mode" do
    client = EPDQ::Client.new(**@client_config.merge(
      test_mode: false,
      enable_utf8: false
    ))

    request = EPDQ::Request.new(client)

    assert_equal "https://payments.epdq.co.uk/ncol/prod/orderstandard.asp", request.request_url
  end

  test "request_url in test mode when UTF8 is enabled" do
    client = EPDQ::Client.new(**@client_config.merge(
      test_mode: true,
      enable_utf8: true
    ))

    request = EPDQ::Request.new(client)

    assert_equal "https://mdepayments.epdq.co.uk/ncol/test/orderstandard_utf8.asp", request.request_url
  end

  test "request_url in live mode when UTF8 is enabled" do
    client = EPDQ::Client.new(**@client_config.merge(
      test_mode: false,
      enable_utf8: true
    ))

    request = EPDQ::Request.new(client)

    assert_equal "https://payments.epdq.co.uk/ncol/prod/orderstandard_utf8.asp", request.request_url
  end
end
