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
  autoload 'Redfin', 'sherlock_homes/redfin'
  autoload 'Trulia', 'sherlock_homes/trulia'
  autoload 'Zillow', 'sherlock_homes/zillow'
end
