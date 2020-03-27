require "spec_helper"

RSpec.describe Affirm::Client, ".void" do
  before do
    Affirm.configure do |config|
      config.environment = "sandbox"
      config.public_api_key = "public_api_key"
      config.private_api_key = "private_api_key"
    end
  end
  let(:transaction_id) { "LS-4BSY-SV6E" }

  subject { Affirm::Client.new.void(transaction_id) }

  it "Voids the payment and creates a transaction event" do
    stub = stub_request(:post, "https://sandbox.affirm.com/api/v1/transactions/#{transaction_id}/void")
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
      ).to_return(read_http_fixture("void/success.http"))

    response = subject
    expect(stub).to have_been_requested
    expect(response).to be_a(Affirm::Struct::Transaction::Event)
    expect(response.id).to eql "LSE-7MZU-P24E"
    expect(response.currency).to eql "USD"
    expect(response.type).to eql "void"
  end

  context "when not authorized" do
    it "raises a RequestError" do
      stub = stub_request(:post, "https://sandbox.affirm.com/api/v1/transactions/#{transaction_id}/void")
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
        ).to_return(read_http_fixture("void/not_authorized.http"))
      expect { subject }.to raise_error(Affirm::RequestError, "The transaction must be authorized before it may be voided.")
      expect(stub).to have_been_requested
    end
  end

  context "when already captured" do
    let(:transaction_id) { "DVEP-FTQO" }
    it "raises a RequestError" do
      stub = stub_request(:post, "https://sandbox.affirm.com/api/v1/transactions/#{transaction_id}/void")
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
        ).to_return(read_http_fixture("void/already_captured.http"))
      expect { subject }.to raise_error(Affirm::RequestError, "The transaction has been captured and may no longer be voided.")
      expect(stub).to have_been_requested
    end
  end
end
