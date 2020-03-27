require "spec_helper"

RSpec.describe Affirm::Client, "starting_checkout" do
  before do
    Affirm.configure do |config|
      config.environment = "sandbox"
      config.public_api_key = "public_api_key"
      config.private_api_key = "private_api_key"
    end
  end

  let(:payload) { read_json_fixture("create_checkout_payload.json") }
  let(:endpoint) { "https://sandbox.affirm.com/api/v2/checkout/store" }
  let(:success_fixture) { read_http_fixture("checkout_store/success.http") }

  describe "start_checkout_store" do
    subject { Affirm::Client.new.start_checkout_store(payload) }

    it "stores the checkout object and return redirect_url" do
      stubbed_request = stub_the_request
      response = subject
      expect(stubbed_request).to have_been_requested
      expect(response).to be_a(Affirm::Struct::Checkout::Response)

      expect(response.checkout_id).to eql "HEYR6TCV4VBX6NPM"
      expect(response.redirect_url).to eql "https://sandbox.affirm.com/checkout/2BG5HE7ZYT2VY1GH/new/HEYR6TCV4VBX6NPM/"
    end
  end

  describe "start_checkout_direct" do
    let(:endpoint) { "https://sandbox.affirm.com/api/v2/checkout/direct" }
    let(:success_fixture) { read_http_fixture("checkout_direct/success.http") }
    subject { Affirm::Client.new.start_checkout_direct(payload) }

    it "stores the checkout object and return redirect_url" do
      stubbed_request = stub_the_request
      response = subject
      expect(stubbed_request).to have_been_requested
      expect(response).to be_a(Affirm::Struct::Checkout::Response)

      expect(response.checkout_id).to eql "OLBQZ611UBBCDZ28"
      expect(response.redirect_url).to eql "https://sandbox.affirm.com/checkout/2BG5HE7ZYT2VY1GH/new/OLBQZ611UBBCDZ28/"
    end
  end

  private

  def stub_the_request
    stub_request(:post, endpoint)
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
      )
      .with(
        body: payload.to_json
      ).to_return(success_fixture)
  end
end
