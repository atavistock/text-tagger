require "bundler/setup"
require "text_tagger"

RSpec.configure do |config|
  # Setup the database for testing
  ActiveRecord::Base.establish_connection(
    'adapter'  => 'sqlite3',
    'database' => 'test.sqlite3'
  )

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
