module SherlockHomes::Scraper
  class << self

    def scrapers
      @@scrapers ||= {}
    end

    def register_scraper(scraper)
      name = scraper[:name]
      scrapers[name] = scraper[:class]

      self.class.instance_eval do
        define_method("from_#{name}") do |url|
          scraper = scrapers[name].new
          scraper.base_url(url)
          scraper.crawl
        end
      end
    end

  end
end

# Register all scrapers
require 'sherlock_homes/scraper/base'

Dir[File.join(File.dirname(__FILE__), 'scraper', "*.rb")].each do |file|
  require file
end
