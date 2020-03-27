module Affirm
  module Struct
    class Transaction < Base
      attr_accessor :id
      attr_accessor :amount
      attr_accessor :amount_refunded
      attr_accessor :authorization_expiration
      attr_accessor :checkout_id
      attr_accessor :created
      attr_accessor :currency
      attr_accessor :events
      attr_accessor :order_id
      attr_accessor :provider_id
      attr_accessor :status
    end
  end
end
