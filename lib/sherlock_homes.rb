require 'active_support'
require 'active_support/core_ext'
require 'capybara'
require 'capybara/poltergeist'
require 'geocoder'
require 'rubillow'
require 'site_prism'

require 'sherlock_homes/version'

module SherlockHomes

  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield config
  end

  autoload 'Configuration', 'sherlock_homes/configuration'
  autoload 'Driver',        'sherlock_homes/driver'
  autoload 'Locator',       'sherlock_homes/locator'
  autoload 'Redfin',        'sherlock_homes/redfin'
  autoload 'Scraper',       'sherlock_homes/scraper'
  autoload 'Trulia',        'sherlock_homes/trulia'
  autoload 'Zillow',        'sherlock_homes/zillow'
end
