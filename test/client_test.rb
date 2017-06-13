# frozen_string_literal: true
require "test_helper"

class ClientTest < Test::Unit::TestCase
  test "default client config" do
    client = EPDQ::Client.new(
      pspid: "MYPSPID",
      sha_in: "MYSHAIN",
      sha_out: "MYSHAOUT"
    )

    assert_equal :sha512, client.sha_type
    assert_equal true, client.test_mode
    assert_equal true, client.enable_utf8
  end

  test "setting client config" do
    client = EPDQ::Client.new(
      pspid: "MYPSPID",
      sha_in: "MYSHAIN",
      sha_out: "MYSHAOUT",
      sha_type: :sha512,
      test_mode: false,
      enable_utf8: true
    )

    assert_equal "MYPSPID", client.pspid
    assert_equal "MYSHAIN", client.sha_in
    assert_equal "MYSHAOUT", client.sha_out
    assert_equal :sha512, client.sha_type
    assert_equal false, client.test_mode
    assert_equal true, client.enable_utf8
  end

  test "can create a request" do
    client = EPDQ::Client.new(
      pspid: "MYPSPID",
      sha_in: "MYSHAIN",
      sha_out: "MYSHAOUT"
    )

    EPDQ::Request.expects(:new).with(client, param: 1).returns(:result)
    assert_equal :result, client.request(param: 1)
  end

  test "can create a response" do
    client = EPDQ::Client.new(
      pspid: "MYPSPID",
      sha_in: "MYSHAIN",
      sha_out: "MYSHAOUT"
    )

    EPDQ::Response.expects(:new).with(client, "query_string").returns(:result)
    assert_equal :result, client.response("query_string")
  end
end
