require 'active_support'
require 'active_support/core_ext'
require 'capybara'
require 'capybara/poltergeist'
require 'geocoder'
require 'site_prism'
require 'visiflow'

require 'sherlock_homes/configuration'
require 'sherlock_homes/rubillow'
require 'sherlock_homes/version'

module SherlockHomes
  autoload 'Driver',        'sherlock_homes/driver'
  autoload 'Locator',       'sherlock_homes/locator'
  autoload 'Redfin',        'sherlock_homes/redfin'
  autoload 'Scraper',       'sherlock_homes/scraper'
  autoload 'Trulia',        'sherlock_homes/trulia'
  autoload 'Zillow',        'sherlock_homes/zillow'
end
