module Affirm
  module Struct
    class Checkout < Base
      attr_accessor :api_version
      attr_accessor :billing
      attr_accessor :checkout_flow_type
      attr_accessor :checkout_status
      attr_accessor :checkout_type
      attr_accessor :config
      attr_accessor :currency
      attr_accessor :discounts
      attr_accessor :financing_program_external_name
      attr_accessor :financing_program_name
      attr_accessor :items
      attr_accessor :loan_type
      attr_accessor :merchant
      attr_accessor :merchant_external_reference
      attr_accessor :mfp_rule_input_data
      attr_accessor :order_id
      attr_accessor :product
      attr_accessor :shipping
      attr_accessor :shipping_amount
      attr_accessor :tax_amount
      attr_accessor :total
    end
  end
end
