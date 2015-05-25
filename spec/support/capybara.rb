RSpec.configure do |config|

  config.append_after do
    SherlockHomes::Scraper.restart_phantomjs
  end

end
