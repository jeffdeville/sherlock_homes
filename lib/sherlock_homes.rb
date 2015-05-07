require "sherlock_homes/version"

require 'geocoder'
require 'rubillow'

module SherlockHomes

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  autoload 'Configuration', 'sherlock_homes/configuration'
  autoload 'Locator', 'sherlock_homes/locator'
  autoload 'PropertyFinder', 'sherlock_homes/property_finder'
end
