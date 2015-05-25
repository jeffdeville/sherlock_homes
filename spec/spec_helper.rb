$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dotenv'
require 'rspec/given'
require 'webmock/rspec'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'

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
  config.warnings = false

  config.after :each do |example|
    if example.exception
      Capybara::Screenshot.screenshot_and_save_page
    end
  end
end


Capybara::Screenshot.webkit_options = { width: 1024, height: 768 }
Capybara::Screenshot.prune_strategy = { keep: 20 }
