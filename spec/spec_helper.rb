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

RSpec.configure do |config|
  config.before :suite do
    SherlockHomes.configure do |config|
      config.driver = :poltergeist
      config.wait_time = 60
      config.timeout = 60
      config.debug = false
      #config.proxy_port = '2424'
      #config.proxy_host = '127.0.0.1'
    end
    SherlockHomes::Driver.load!
  end

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

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Capybara::Screenshot.webkit_options = { width: 1024, height: 768 }
Capybara::Screenshot.prune_strategy = { keep: 20 }
