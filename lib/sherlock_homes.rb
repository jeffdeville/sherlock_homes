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
  autoload 'Google',        'sherlock_homes/google'
  autoload 'Locator',       'sherlock_homes/locator'
  autoload 'Normalizer',    'sherlock_homes/normalizer'
  autoload 'Property',      'sherlock_homes/model/property'
  autoload 'Pipeline',      'sherlock_homes/pipeline'
  autoload 'Redfin',        'sherlock_homes/redfin'
  autoload 'Scraper',       'sherlock_homes/scraper'
  autoload 'Trulia',        'sherlock_homes/trulia'
  autoload 'Zillow',        'sherlock_homes/zillow'
end
