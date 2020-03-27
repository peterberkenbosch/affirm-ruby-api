require "spec_helper"

RSpec.describe Affirm::Client, ".get_checkout" do
  before do
    Affirm.configure do |config|
      config.environment = "sandbox"
      config.public_api_key = "public_api_key"
      config.private_api_key = "private_api_key"
    end
  end
  let(:checkout_id) { "HEYR6TCV4VBX6NPM" }
  subject { Affirm::Client.new.get_checkout(checkout_id) }

  it "returns the Affirm checkout object" do
    stub = stub_request(:get, "https://sandbox.affirm.com/api/v2/checkout/#{checkout_id}")
      .with(
        headers: {
          "Accept" => "application/json",
          "Content-type" => "application/json",
          "User-Agent" => /^Affirm\/#{Affirm::VERSION} Ruby\/#{RUBY_VERSION} OpenSSL\/.*$/
        }
      )
      .with(
        basic_auth: [
          Affirm.config.public_api_key,
          Affirm.config.private_api_key
        ]
      ).to_return(read_http_fixture("get_checkout/success.http"))

    response = subject
    expect(stub).to have_been_requested
    expect(response).to be_a(Affirm::Struct::Checkout)
  end
end
