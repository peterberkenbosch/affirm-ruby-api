module Affirm
  class Configuration
    attr_accessor :public_api_key
    attr_accessor :private_api_key
    attr_reader :environment

    ENDPOINTS = {
      production: "api.affirm.com",
      production_ca: "api.affirm.ca",
      sandbox: "sandbox.affirm.com",
      sandbox_ca: "sandbox.affirm.ca"
    }

    def initialize
      @environment = :production
    end

    def environment=(env)
      @environment = env.to_sym
    end

    def endpoint
      "https://#{ENDPOINTS[environment]}"
    end
  end

  class << self
    def config
      @configuration ||= Configuration.new
    end

    attr_writer :configuration

    def configure
      yield config
    end
  end
end
