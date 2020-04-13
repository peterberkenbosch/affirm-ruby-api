require "spec_helper"

RSpec.describe Affirm::Client, ".get_checkout" do
  let(:checkout_id) { "HEYR6TCV4VBX6NPM" }
  subject { Affirm::Client.new.get_checkout(checkout_id) }

  it "returns the Affirm checkout object" do
    stub = stub_request(:get, "https://sandbox.affirm.com/api/v2/checkout/#{checkout_id}")
      .with(headers: stub_headers)
      .with(basic_auth: stub_basic_auth)
      .to_return(read_http_fixture("get_checkout/success.http"))

    response = subject
    expect(stub).to have_been_requested
    expect(response).to be_a(Affirm::Struct::Checkout)
  end
end
