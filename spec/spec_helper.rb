require "simplecov"
SimpleCov.start

require "bundler/setup"
require "affirm"
require "affirm/testing_support/http_responses"
require "pry"

Dir[File.join(File.expand_path(__dir__), "support/**/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Affirm.configure do |config|
  config.environment = :sandbox
  config.public_api_key = "public_api_key"
  config.private_api_key = "private_api_key"
end
