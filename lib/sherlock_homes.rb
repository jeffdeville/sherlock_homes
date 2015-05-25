require 'active_support'
require 'active_support/core_ext'
require 'geocoder'
require 'rubillow'
require 'site_prism'

require 'sherlock_homes/version'
require 'sherlock_homes/capybara'

module SherlockHomes

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  autoload 'Configuration', 'sherlock_homes/configuration'
  autoload 'Locator', 'sherlock_homes/locator'
  autoload 'Redfin', 'sherlock_homes/redfin'
  autoload 'Scraper', 'sherlock_homes/scraper'
  autoload 'Trulia', 'sherlock_homes/trulia'
  autoload 'Zillow', 'sherlock_homes/zillow'
end
