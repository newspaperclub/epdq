ePDQ
====

ePDQ is a Ruby library for interfacing with Barclaycard's ePDQ payment gateway.

Usage
-----

First, configure the EPDQ module for your settings:

    EPDQ.pspid    = "foo"
    EPDQ.sha_type = :sha1 # or :sha256, :sha512
    EPDQ.sha_in   = "yourshainstring"
    EPDQ.sha_out  = "yourshaoutstring"

If you would like to use the UTF8 enabled endpoints:

    EPDQ.enable_utf8 = true

Then you can build the form for a user to POST to, starting in the controller:
All the options keys are named after the downcased fields in the [ePDQ
documentation](https://mdepayments.epdq.co.uk/ncol/ePDQ_e-Com-ADV_EN.pdf),
provided as symbols or strings.

    parameters = {
      :amount => 1500,
      :currency => "EUR",
      :language => "en_US",
      :orderid => "1234"
    }

    @epdq_request = EPQD::Request.new(parameters)

Then in a Rails view, you might do something like this:

    <%= form_tag @epdq_request.request_url do |f| %>
      <%- @epdq_request.form_attributes.each do |k, v| -%>
        <%= hidden_field_tag k, v %>
      <%- end -%>

      <%= submit_tag "Pay with a credit or debit card" %>
    <%- end -%>

And voila, the form is generated with the correct values, including the SHASIGN
field.
