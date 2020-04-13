require "spec_helper"

RSpec.describe Affirm::Client, ".refund" do
  let(:transaction_id) { "K4EF-HM02" }
  subject { Affirm::Client.new.refund(transaction_id) }

  context "with amount not specified" do
    it "will refund the complete transaction amount" do
      stub = stub_request(:post, "https://sandbox.affirm.com/api/v1/transactions/#{transaction_id}/refund")
        .with(headers: stub_headers)
        .with(basic_auth: stub_basic_auth)
        .to_return(read_http_fixture("refund/success.http"))

      response = subject
      expect(stub).to have_been_requested
      expect(response).to be_a(Affirm::Struct::Transaction::Event)
      expect(response.id).to eql "PM7VIBJBLOPC9YNA"
      expect(response.amount).to eql 105420
      expect(response.currency).to eql "USD"
      expect(response.type).to eql "refund"
    end
  end

  context "with amount specified" do
    let(:amount) { 25000 }
    let(:payload) { read_json_fixture("partially_refund.json") }
    subject { Affirm::Client.new.refund(transaction_id, amount) }

    it "does a partial refund" do
      stub = stub_request(:post, "https://sandbox.affirm.com/api/v1/transactions/#{transaction_id}/refund")
        .with(headers: stub_headers)
        .with(basic_auth: stub_basic_auth)
        .with(body: payload.to_json)
        .to_return(read_http_fixture("refund/partially_refund_success.http"))

      response = subject
      expect(stub).to have_been_requested
      expect(response).to be_a(Affirm::Struct::Transaction::Event)
      expect(response.id).to eql "J4TBOU2ZXVGB7IHJ"
      expect(response.amount).to eql 25000
      expect(response.currency).to eql "USD"
      expect(response.type).to eql "refund"
    end
  end

  context "when transaction is already voided" do
    it "raises a RequestError" do
      stub = stub_request(:post, "https://sandbox.affirm.com/api/v1/transactions/#{transaction_id}/refund")
        .with(headers: stub_headers)
        .with(basic_auth: stub_basic_auth)
        .to_return(read_http_fixture("refund/already_voided.http"))

      expect { subject }.to raise_error(Affirm::RequestError, "The transaction has been voided and cannot be refunded.")
      expect(stub).to have_been_requested
    end
  end

  context "when transaction is authorized" do
    it "raises a RequestError" do
      stub = stub_request(:post, "https://sandbox.affirm.com/api/v1/transactions/#{transaction_id}/refund")
        .with(headers: stub_headers)
        .with(basic_auth: stub_basic_auth)
        .to_return(read_http_fixture("refund/not_captured_yet.http"))

      expect { subject }.to raise_error(Affirm::RequestError, "The transaction is authorized and may not be refunded. Try voiding the transaction instead.")
      expect(stub).to have_been_requested
    end
  end
end
