require 'test_helper'

class ResponseTest < Test::Unit::TestCase

  setup do
    EPDQ.sha_type = :sha1
    EPDQ.sha_out = "Mysecretsig1875!?"
  end

  test "valid_sha?" do
    query_string = "ACCEPTANCE=1234&AMOUNT=15.00&BRAND=VISA&CARDNO=xxxxxxxxxxxx1111&CURRENCY=EUR&NCERROR=0&ORDERID=12&PAYID=32100123&PM=CreditCard&STATUS=9&SHASIGN=8DC2A769700CA4B3DF87FE8E3B6FD162D6F6A5FA"

    response = EPDQ::Response.new(query_string)
    assert response.valid_shasign?
  end

  test "valid_sha? with mixed case keys" do
    query_string = "ACCEPTANCE=1234&AMOUNT=15.00&brand=VISA&CARDNO=xxxxxxxxxxxx1111&CURRENCY=EUR&ncerror=0&ORDERID=12&PAYID=32100123&PM=CreditCard&STATUS=9&SHASIGN=8DC2A769700CA4B3DF87FE8E3B6FD162D6F6A5FA"

    response = EPDQ::Response.new(query_string)
    assert response.valid_shasign?
  end

  test "valid_sha? with mssing SHASIGN parameter" do
    query_string = "ACCEPTANCE=1234"

    assert_raise(EPDQ::MissingOrEmptyShasign.new("missing or empty SHASIGN parameter")) do
      EPDQ::Response.new(query_string).valid_shasign?
    end
  end

  test "valid_sha? with empty SHASIGN parameter" do
    query_string = "ACCEPTANCE=1234SHASIGN="

    assert_raise(EPDQ::MissingOrEmptyShasign.new("missing or empty SHASIGN parameter")) do
      EPDQ::Response.new(query_string).valid_shasign?
    end
  end

  test "parameters" do
    query_string = "ACCEPTANCE=1234&AMOUNT=15.00&BRAND=VISA&CARDNO=xxxxxxxxxxxx1111&CURRENCY=EUR&NCERROR=0&ORDERID=12&PAYID=32100123&PM=CreditCard&STATUS=9&SHASIGN=8DC2A769700CA4B3DF87FE8E3B6FD162D6F6A5FA"

    response = EPDQ::Response.new(query_string)
    parameters = response.parameters

    assert_equal 10, parameters.keys.length
    assert_equal "1234", parameters[:acceptance]
    assert_equal "15.00", parameters[:amount]
    assert_equal "VISA", parameters[:brand]
    assert_equal "xxxxxxxxxxxx1111", parameters[:cardno]
    assert_equal "EUR", parameters[:currency]
    assert_equal "0", parameters[:ncerror]
    assert_equal "12", parameters[:orderid]
    assert_equal "32100123", parameters[:payid]
    assert_equal "CreditCard", parameters[:pm]
    assert_equal "9", parameters[:status]
  end

end
