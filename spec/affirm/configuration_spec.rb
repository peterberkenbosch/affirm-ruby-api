require "spec_helper"

RSpec.describe Affirm::Configuration do
  after { restore_config }

  context "when public_api_key is specified" do
    before do
      Affirm.configure do |config|
        config.public_api_key = "abc"
      end
    end

    it "returns public api key" do
      expect(Affirm.config.public_api_key).to eq("abc")
    end
  end

  context "when private_api_key is specified" do
    before do
      Affirm.configure do |config|
        config.private_api_key = "xyz"
      end
    end

    it "returns private api key" do
      expect(Affirm.config.private_api_key).to eq("xyz")
    end
  end

  context "when environment is not specified" do
    before do
      Affirm.configure {}
    end

    it "defaults to production" do
      expect(Affirm.config.environment).to eq(:production)
    end
  end

  context "when environment is set to production" do
    before do
      Affirm.configure do |config|
        config.environment = :production
      end
    end

    it "sets environment to production" do
      expect(Affirm.config.environment).to eq(:production)
    end

    it "sets endpoint to production" do
      expect(Affirm.config.endpoint).to eq("https://api.affirm.com")
    end
  end

  context "when environment is set to sandbox" do
    context "via string" do
      before do
        Affirm.configure do |config|
          config.environment = "sandbox"
        end
      end

      it "sets environment to sandbox" do
        expect(Affirm.config.environment).to eq(:sandbox)
      end

      it "sets endpoint to sandbox" do
        expect(Affirm.config.endpoint).to eq("https://sandbox.affirm.com")
      end
    end

    context "via symbol" do
      before do
        Affirm.configure do |config|
          config.environment = :sandbox
        end
      end

      it "sets environment to sandbox" do
        expect(Affirm.config.environment).to eq(:sandbox)
      end

      it "sets endpoint to sandbox" do
        expect(Affirm.config.endpoint).to eq("https://sandbox.affirm.com")
      end
    end
  end

  private

  def restore_config
    Affirm.configuration = nil
    Affirm.configure {}
  end
end
