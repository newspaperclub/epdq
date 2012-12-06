require 'test_helper'

class RequestTest < Test::Unit::TestCase

  test "defaults to sha1" do
    request = EPDQ::Request.new(:sha_in => "foo")
    assert_equal request.sha_type, :sha1
  end

  test "raises if sha_in is missing" do
    assert_raises do
      EPDQ::Request.new({})
    end
  end

  test "raises if sha_type is incorrect" do
    assert_raises do
      EPDQ::Request.new({ :sha_in => "foo", :sha_type => "foo" })
    end
  end

  %w(sha1 sha256 sha512).each do |sha_type|
    test "initializes with sha_type of #{sha_type}" do
      request = EPDQ::Request.new({ :sha_in => "foo", :sha_type => sha_type })
      assert_equal request.sha_type, sha_type.to_sym
    end
  end

  test "shasign (sha1) calculates correctly" do
    # this sample taken from the documentation available here:
    # https://mdepayments.epdq.co.uk/ncol/ePDQ_e-Com-ADV_EN.pdf
    options = {
      :amount => 1500,
      :currency => "EUR",
      :language => "en_US",
      :orderid => "1234",
      :pspid => "MyPSPID",
      :sha_in => "Mysecretsig1875!?"
    }

    request = EPDQ::Request.new(options)

    assert_equal "F4CC376CD7A834D997B91598FA747825A238BE0A", request.shasign 
  end

  test "shasign (sha256) calculates correctly" do
    options = {
      :amount => 1500,
      :currency => "EUR",
      :language => "en_US",
      :orderid => "1234",
      :pspid => "MyPSPID",
      :sha_in => "Mysecretsig1875!?",
      :sha_type => "sha256"
    }

    request = EPDQ::Request.new(options)

    assert_equal "E019359BAA3456AE5A986B6AABD22CF1B3E09438739E97F17A7F61DF5A11B30F", request.shasign 
  end

  test "shasign (sha512) calculates correctly" do
    options = {
      :amount => 1500,
      :currency => "EUR",
      :language => "en_US",
      :orderid => "1234",
      :pspid => "MyPSPID",
      :sha_in => "Mysecretsig1875!?",
      :sha_type => "sha512"
    }

    request = EPDQ::Request.new(options)

    assert_equal "D1CFE8833A297D0922E908B2B44934B09EE966EF1584DC0D696304E07BB58BA71973C2383C831D878D8A243BB7D7DFFFBE53CEE21955CDFEF44FE82E551F859D", request.shasign 
  end

end
