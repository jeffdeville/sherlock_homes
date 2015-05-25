RSpec.configure do |config|

  config.before(:each) do
    SherlockHomes::Scraper.restart_phantomjs
  end

end
