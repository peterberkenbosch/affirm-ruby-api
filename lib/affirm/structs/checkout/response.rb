module Affirm
  module Struct
    class Checkout::Response < Base
      # @return [String] The checkout ID for Affirm payment.
      attr_accessor :checkout_id

      # @return [String] The Affirm hosted URL checkout generated.
      attr_accessor :redirect_url
    end
  end
end
