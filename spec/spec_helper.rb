require "bundler/setup"
require "byebug"
require "pdf/extract"
require "ostruct"

spec_path = File.join(File.expand_path("../", __FILE__))
Dir[File.join(spec_path, "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
