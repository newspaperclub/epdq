ePDQ
====

ePDQ is a Ruby library for interfacing with Barclaycard's ePDQ payment gateway.

Usage
-----

First, create a new EPDQ client with your settings:

    client = EPDQ::Client.new(
      pspid: "foo",
      sha_in: "yourshainstring",
      sha_out: "yourshaoutstring"
    )

Then you can build the form for a user to POST to, starting in the controller:
All the options keys are named after the down-cased fields in the [ePDQ
documentation](https://mdepayments.epdq.co.uk/ncol/ePDQ_e-Com-ADV_EN.pdf),
provided as symbols or strings.

    parameters = {
      amount: 1500,
      currency: "EUR",
      language: "en_US",
      orderid: "1234"
    }

    @epdq_request = client.request(parameters)

Then in a Rails view, you might do something like this:

    <%= form_tag @epdq_request.request_url do |f| %>
      <%- epdq_request.form_attributes.each do |k, v| -%>
        <%= hidden_field_tag k, v %>
      <%- end -%>

      <%= submit_tag "Pay with a credit or debit card" %>
    <%- end -%>

And voila, the form is generated with the correct values, including the SHASIGN
field.

EPDQ::Client settings
---------------------

The supported options when creating a new client using `EPDQ::Client.new`:

| Key         | Required? | Type    | Default value | Supported values        |
|:------------|:----------|:--------|:--------------|:------------------------|
| pspid       | Yes       | String  | -             | -                       |
| sha_in      | Yes       | String  | -             | -                       |
| sha_out     | Yes       | String  | -             | -                       |
| sha_type    | No        | Symbol  | :sha512       | :sha1, :sha256, :sha512 |
| test_mode   | No        | Boolean | true          | -                       |
| enable_utf8 | No        | Boolean | true          | -                       |
