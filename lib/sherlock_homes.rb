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
  autoload 'CLI',           'sherlock_homes/cli'
  autoload 'Downloader',    'sherlock_homes/downloader'
  autoload 'Driver',        'sherlock_homes/driver'
  autoload 'Locator',       'sherlock_homes/locator'
  autoload 'Mapper',        'sherlock_homes/mapper'
  autoload 'Normalizer',    'sherlock_homes/normalizer'
  autoload 'Property',      'sherlock_homes/model/property'
  autoload 'Pipeline',      'sherlock_homes/pipeline'
  autoload 'Scraper',       'sherlock_homes/scraper'
  autoload 'Zillow',        'sherlock_homes/zillow'
end
