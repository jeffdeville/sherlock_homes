require 'sherlock_homes/version'

require 'geocoder'
require 'rubillow'
require 'yasf'

module SherlockHomes

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  autoload 'Configuration', 'sherlock_homes/configuration'
  autoload 'Locator', 'sherlock_homes/locator'
  autoload 'Scraper', 'sherlock_homes/scraper'
  autoload 'PropertyFinder', 'sherlock_homes/property_finder'
end
