RSpec.configure do |config|
  config.before :suite do
    Yasf.configure do |config|
      #config.proxy_port = '2424'
      #config.proxy_host = '127.0.0.1'
      config.timeout = 100
      config.debug = false
      config.capybara_driver = :sauce
    end
  end
end
