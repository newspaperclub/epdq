require 'test_helper'

class RequestTest < Test::Unit::TestCase

  setup do
    EPDQ.sha_in = "Mysecretsig1875!?"
    EPDQ.pspid = "MyPSPID"
    EPDQ.sha_type = :sha1
  end

  test "shasign (sha1) calculates correctly" do
    # this sample taken from the documentation available here:
    # https://mdepayments.epdq.co.uk/ncol/ePDQ_e-Com-ADV_EN.pdf
    options = {
      :amount => 1500,
      :currency => "EUR",
      :language => "en_US",
      :orderid => "1234"
    }

    request = EPDQ::Request.new(options)

    assert_equal "F4CC376CD7A834D997B91598FA747825A238BE0A", request.shasign 
  end

  test "shasign (sha256) calculates correctly" do
    EPDQ.sha_type = :sha256

    options = {
      :amount => 1500,
      :currency => "EUR",
      :language => "en_US",
      :orderid => "1234"
    }

    request = EPDQ::Request.new(options)

    assert_equal "E019359BAA3456AE5A986B6AABD22CF1B3E09438739E97F17A7F61DF5A11B30F", request.shasign 
  end

  test "shasign (sha512) calculates correctly" do
    EPDQ.sha_type = :sha512

    options = {
      :amount => 1500,
      :currency => "EUR",
      :language => "en_US",
      :orderid => "1234"
    }

    request = EPDQ::Request.new(options)

    assert_equal "D1CFE8833A297D0922E908B2B44934B09EE966EF1584DC0D696304E07BB58BA71973C2383C831D878D8A243BB7D7DFFFBE53CEE21955CDFEF44FE82E551F859D", request.shasign 
  end

  test "form_attributes" do
    # this sample taken from the documentation available here:
    # https://mdepayments.epdq.co.uk/ncol/ePDQ_e-Com-ADV_EN.pdf
    options = {
      :amount => 1500,
      :currency => "EUR",
      :language => "en_US",
      :orderid => "1234"
    }

    request = EPDQ::Request.new(options)

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
    EPDQ.test_mode = true
    request = EPDQ::Request.new
    
    assert_equal EPDQ::Request::TEST_URL, request.request_url
  end

  test "request_url in live mode" do
    EPDQ.test_mode = false
    request = EPDQ::Request.new
    
    assert_equal EPDQ::Request::LIVE_URL, request.request_url
  end

end
