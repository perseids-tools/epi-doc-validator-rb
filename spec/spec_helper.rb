require 'bundler/setup'
require 'epi_doc_validator'
require 'pry-byebug'
require 'rspec/its'

def fixture(file)
  File.read(File.expand_path(File.join('fixtures/files/', file), __dir__))
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
