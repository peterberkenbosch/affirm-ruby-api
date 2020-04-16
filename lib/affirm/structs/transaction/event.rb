module Affirm
  module Struct
    class Transaction::Event < Base
      attr_accessor :id
      attr_accessor :amount
      attr_accessor :created
      attr_accessor :type
      attr_accessor :fee
      attr_accessor :currency
    end
  end
end
