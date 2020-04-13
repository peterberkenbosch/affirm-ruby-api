require "spec_helper"

RSpec.describe Affirm::Client do
  subject { Affirm::Client.new }

  describe "user_agent_string" do
    it "has this gem version, with ruby and OpenSSL version" do
      expect(subject.user_agent_string).to match(/^Affirm\/#{Affirm::VERSION} Ruby\/#{RUBY_VERSION} OpenSSL\/.*$/)
    end
  end

  describe "http_call" do
    context ":get with default params" do
      it "will build a proper request" do
        stub = stub_request(:get, "https://sandbox.affirm.com/api/v2/method")
          .with(headers: stub_headers)
          .with(basic_auth: stub_basic_auth)
          .to_return(status: 200, body: "{}", headers: {})

        subject.http_call(:get, :method)
        expect(stub).to have_been_requested
      end

      context "with the new transactions api" do
        it "calls the /api/v1 path" do
          stub = stub_request(:get, "https://sandbox.affirm.com/api/v1/transactions")
            .with(headers: stub_headers)
            .with(basic_auth: stub_basic_auth)
            .to_return(read_http_fixture("get_transaction/success.http"))

          subject.http_call(:get, :transactions)
          expect(stub).to have_been_requested
        end
      end
    end

    describe "using invalid api keys" do
      it "will raise AuthenticationError" do
        stub = stub_request(:get, "https://sandbox.affirm.com/api/v2/method")
          .with(headers: stub_headers)
          .with(basic_auth: stub_basic_auth)
          .to_return(read_http_fixture("authentication_failed.http"))

        expect { subject.http_call(:get, :method) }.to raise_error(Affirm::AuthenticationError, "You have provided an invalid API key pair.")
        expect(stub).to have_been_requested
      end
    end

    describe "using another http method then :post or :get" do
      it "will raise a RequestError" do
        expect { subject.http_call(:patch, :foo) }.to raise_error(Affirm::RequestError, "Invalid HTTP Method: PATCH")
      end
    end

    describe "when request times out" do
      it "will raise a RequestError" do
        stub = stub_request(:get, "https://sandbox.affirm.com/api/v2/method")
          .with(headers: stub_headers)
          .with(basic_auth: stub_basic_auth)
          .to_timeout

        expect { subject.http_call(:get, :method) }.to raise_error(Affirm::RequestError, "execution expired")
        expect(stub).to have_been_requested
      end
    end

    # Affirm api currently does not returns a proper 404 message as documented
    # it's a XML document with unrelated error message. The http status code
    # however is a 404. So we go on that and leave the message empty.
    describe "when we get a 404" do
      it "will raise a NotFoundError" do
        stub = stub_request(:get, "https://sandbox.affirm.com/api/v2/method")
          .with(headers: stub_headers)
          .with(basic_auth: stub_basic_auth)
          .to_return(read_http_fixture("404_not_found.http"))

        expect { subject.http_call(:get, :method) }.to raise_error(Affirm::NotFoundError)
        expect(stub).to have_been_requested
      end
    end

    describe "when we get a 500" do
      it "will raise a Affirm::Error" do
        stub = stub_request(:get, "https://sandbox.affirm.com/api/v2/method")
          .with(headers: stub_headers)
          .with(basic_auth: stub_basic_auth)
          .to_return(status: 500, body: "{}", headers: {})

        expect { subject.http_call(:get, :method) }.to raise_error(Affirm::Error)
        expect(stub).to have_been_requested
      end
    end
  end
end
