module SherlockHomes
  class Scraper

    def self.restart_phantomjs
      driver = Capybara.current_session.driver
      if driver.is_a?(Capybara::Poltergeist::Driver)
        driver.restart
        driver.add_header 'User-Agent', 'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0'
        driver.add_header 'Accept-Language', 'en'
      end
    end

  end
end
