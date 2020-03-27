module Affirm
  module Struct
    class Base
      def initialize(attributes = {})
        attributes.each do |key, value|
          m = "#{key}=".to_sym
          send(m, value) if respond_to?(m)
        end
      end
    end
  end
end

require_relative "structs/checkout"
require_relative "structs/checkout/response"
require_relative "structs/transaction"
require_relative "structs/transaction/event"
