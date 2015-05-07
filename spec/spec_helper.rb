$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dotenv'
require 'rspec/given'
require 'webmock/rspec'

Dotenv.load('.env')

require 'sherlock_homes'

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

support_files = Dir[File.join(
  File.expand_path('../../spec/support/**/*.rb', __FILE__)
)]
support_files.each { |f| require f }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = :random
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.warnings = true
end
