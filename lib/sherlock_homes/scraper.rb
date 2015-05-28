module SherlockHomes
  class Scraper

    def self.restart_phantomjs
      driver = Capybara.current_session.driver
      if driver.is_a?(Capybara::Poltergeist::Driver)
        driver.restart
        driver.add_header 'User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36'
        driver.add_header 'Accept-Language', 'en-US, en'
      end
    end

  end
end
