require 'capybara'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist_crawler do |app|
  driver = Capybara::Poltergeist::Driver.new(
    app, {
      js_errors: false,
      debug: false,
      inspector: false,
      timeout: 90,
      phantomjs_logger: StringIO.new,
      logger: nil,
      phantomjs_options: [
        '--ignore-ssl-errors=yes',
        '--ssl-protocol=any',
        '--web-security=no',
        '--load-images=false'
      ]
    }
  )
  driver
end

Capybara.configure do |config|
  config.default_driver    = :poltergeist_crawler
  config.javascript_driver = :poltergeist_crawler
  config.ignore_hidden_elements = false
  config.default_wait_time = 60
end
