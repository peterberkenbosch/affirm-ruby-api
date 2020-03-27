module RSpecSupportHelpers
  def http_fixture(*names)
    File.join(SPEC_ROOT, "fixtures.http", *names)
  end

  def read_http_fixture(*names)
    File.read(http_fixture(*names))
  end

  def json_fixture(*names)
    File.join(SPEC_ROOT, "fixtures.json", *names)
  end

  def read_json_fixture(*names)
    JSON.parse(File.read(json_fixture(*names)))
  end
end

RSpec.configure do |config|
  config.include RSpecSupportHelpers
end
